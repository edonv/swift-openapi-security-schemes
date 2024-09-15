# OpenAPISecuritySchemes

A WIP

## Supported Schemes

- [x] API Key
  - [x] Query
  - [x] Header
  - [x] Cookie
- [ ] HTTP
  - [x] Basic
  - [x] Bearer
- [ ] Mutual TLS
- [x] OAuth2
- [ ] OpenID Connect Discovery

## To-Do's

- [ ] Add support for more types of security schemes.
- [x] Add OpenAPIRuntime.ClientMiddleware support
- [x] Add OpenAPIRuntime.ServerMiddleware support
- [ ] Eventual "generating" of `WWW-Authenticate` response header values based on instance of `SecurityScheme`
