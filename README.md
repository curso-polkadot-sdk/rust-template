# Rust Base Project
Template de projeto base para criar um workspace em Rust.

## Configuração
Esse projeto já vem com uma configuração padrão para as seguintes ferramentas.
- [rustfmt](https://github.com/rust-lang/rustfmt): ferramenta para formatar código Rust de acordo com diretrizes de estilo definidas do arquivo `.rustfmt.toml`.
- [dprint](https://github.com/dprint/dprint): Ferramenta para formatar arquivos definidios no `dprint.json`, como:
  - markdown (.md)
  - TOML (.toml)
  - JSON (.json)
  - javascript (.js)
  - dockerfiles.
- [clippy](https://github.com/rust-lang/rust-clippy): Coleção de lints para detectar erros comuns e melhorar seu código Rust.
- [cargo-deny](https://github.com/EmbarkStudios/cargo-deny): plugin que analisa o gráfico de dependências do seu projeto para garantir que todas as suas dependências estejam de acordo com suas expectativas e requisitos.
- [shellcheck](https://github.com/koalaman/shellcheck): Análise estática de shell scripts.

## Dependencias
Certifique que o rust esta instalado: https://www.rust-lang.org/tools/install

E para instalar as outras dependencias, siga as instruções abaixo:
```sh
# rustfmt
rustup component add rustfmt --toolchain nightly

# clippy
rustup component add clippy

# dprint
cargo install dprint --force

# cargo-deny
cargo install cargo-deny --force
```

### Instruções por plataforma:

On Debian/Ubuntu/Mint:
```sh
sudo apt install shellcheck
```

On macOS (OS X):
```sh
brew install shellcheck
```

On Windows (via chocolatey):
```cmd
C:\> choco install shellcheck
```

Or Windows (via [winget](https://github.com/microsoft/winget-pkgs)):
```cmd
C:\> winget install --id koalaman.shellcheck
```

Or Windows (via [scoop](http://scoop.sh)):
```cmd
C:\> scoop install shellcheck
```

## Iniciar o projeto
Use os comandos abaixo para criar novos executáveis ou bibliotecas:
```sh
# Para executaveis (main.rs)
cargo new <nome>

# Para bibliotecas (lib.rs)
cargo new --lib <nome>
```
O comando acima irá adicionar automaticamente seu crate ao workspace definido no arquivo `Cargo.toml` definido na base do projeto.

**Importante** lembre-se de definir o campo `license` no arquivo `Cargo.toml` do crate recem criado, caso contrário o `cargo-deny` irá falhar.

## Formatação e Lint
Opção 1: executar usando script (recomendado)
```sh
./scripts/check.sh
```

Opção 2: executar manualmente
```bash
# Formatar código rust
cargo +nightly fmt --all

# Formatar .toml, .md, .json, etc...
dprint fmt

# Verificar vulnerabilidades e dependencias.
cargo deny check

# Verificar boas práticas de código e compatibilidade de licenças.
cargo clippy --locked \
  --workspace \
  --examples \
  --tests \
  --all-features \
  -- \
  -Dwarnings \
  -Dclippy::unwrap_used \
  -Dclippy::expect_used \
  -Dclippy::nursery \
  -Dclippy::pedantic \
  -Aclippy::module_name_repetitions

# Verificar boas práticas em código shell/bash
shellcheck --enable=all --severity=style ./scripts/*.sh
```
