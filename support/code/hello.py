def hello(name):
    """Return a greeting."""
    return f'Hello {name}!'


if __name__ == '__main__':
    for who in ('world', 'LaTeX'):
        print(hello(who))
