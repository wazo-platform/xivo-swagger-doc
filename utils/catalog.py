#!/usr/bin/env python
import abc
import os
import shutil
import json
import fnmatch
import click


class SpecScanner(object):

    def __init__(self, root):
        self.root = root

    def scan(self):
        for path, dirs, files in os.walk(self.root):
            json_files = fnmatch.filter(files, '*.json')
            for filepath, spec in self.filter_specs(path, json_files):
                yield filepath, spec

    def filter_specs(self, path, json_files):
        for filename in json_files:
            filepath = os.path.join(path, filename)
            spec = self.load_spec(filepath)
            if spec and self.is_swagger_spec(spec):
                yield filepath, spec

    def load_spec(self, filepath):
        with open(filepath) as f:
            try:
                return json.loads(f.read())
            except ValueError:
                return None

    def is_swagger_spec(self, spec):
        return spec.get('swagger') >= "2.0"


class CatalogBuilder(object):

    __metaclass__ = abc.ABCMeta

    index_filename = "index.json"

    def __init__(self, destination):
        self.destination = destination

    @abc.abstractmethod
    def build(self, scanner):
        pass

    def write_index(self, items):
        items = self.sort_items(items)
        catalog = {'apis': items}
        index_path = os.path.join(self.destination, self.index_filename)
        data = json.dumps(catalog, indent=4, separators=(',', ': '))
        with open(index_path, 'w') as f:
            f.write(data)

    def sort_items(self, items):
        return sorted(items, key=lambda i: i['title'].lower())


class ServerBuilder(CatalogBuilder):

    def build(self, scanner):
        items = self.build_items(scanner)
        self.write_index(items)

    def build_items(self, scanner):
        return [self.build_item(spec) for _, spec in scanner.scan()]

    def build_item(self, spec):
        return {'title': spec['info']['title'],
                'port': spec['x-xivo-port'],
                'path': '{}/doc/api.json'.format(spec['basePath'])}


class StaticBuilder(CatalogBuilder):

    def __init__(self, destination, prefix="/doc/catalog"):
        super(StaticBuilder, self).__init__(destination)
        self.prefix = prefix

    def build(self, scanner):
        items = []
        for filepath, spec in scanner.scan():
            items.append(self.build_item(spec))
            self.copy_spec(spec, filepath)

        self.write_index(items)

    def build_item(self, spec):
        url = "{}/{}.json".format(self.prefix, spec['x-xivo-name'])
        return {'title': spec['info']['title'],
                'url': url}

    def copy_spec(self, spec, filepath):
        filename = "{}.json".format(spec['x-xivo-name'])
        destination = os.path.join(self.destination, filename)
        shutil.copy(filepath, destination)


@click.command('server')
@click.argument('projects', type=click.Path(exists=True, file_okay=False))
@click.argument('destination', type=click.Path(exists=True, file_okay=False))
def server(projects, destination):
    scanner = SpecScanner(projects)
    builder = ServerBuilder(destination)
    builder.build(scanner)


@click.command('static')
@click.argument('projects', type=click.Path(exists=True, file_okay=False))
@click.argument('destination', type=click.Path(exists=True, file_okay=False))
@click.option('--prefix', help="URL prefix", default="/doc/catalog")
def static(projects, destination, prefix):
    scanner = SpecScanner(projects)
    builder = StaticBuilder(destination, prefix=prefix)
    builder.build(scanner)


if __name__ == "__main__":
    group = click.Group()
    group.add_command(server)
    group.add_command(static)
    group()
