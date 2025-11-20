#!/usr/bin/env bash

# ==========================================
#  ARC — Gerenciador do Arcabouço
#  Uso:
#     ./arc new <template> <path>
# ==========================================

# ----------- funções utilitárias -----------

error() {
    printf "❌ %s\n" "$1"
    exit 1
}

warn() {
    printf "⚠️  %s\n" "$1"
}

info() {
    printf "ℹ️  %s\n" "$1"
}

success() {
    printf "✔ %s\n" "$1"
}

# -------------- comando: new ----------------
cmd_new() {
    local template="$1"
    local path="$2"

    # validação
    [ -z "$template" ] && error "Uso: arc new <template> <path>"
    if [ -z "$path" ]; then
        path="tmp/${template}_$(date +%Y%m%d%H%M%S)"
    fi

    # verifica template
    if [ ! -f "templates/$template.tex" ]; then
        error "Template 'templates/$template.tex' não existe."
    fi

    info "Criando estrutura em: $path"
    mkdir -p "$path" || error "Não foi possível criar o diretório."

    # arquivos alvo
    local tex_target="$path/main.tex"
    local mf_target="$path/makefile"

    # ---- checar se já existem ----

    if [ -f "$tex_target" ]; then
        warn "Arquivo já existe: $tex_target"
        warn "→ Nada será sobrescrito."
        exit 1
    fi

    if [ -f "$mf_target" ]; then
        warn "Arquivo já existe: $mf_target"
        warn "→ Nada será sobrescrito."
        exit 1
    fi

    # ---- copiar template ----
    cp "templates/$template.tex" "$tex_target" \
        || error "Erro ao copiar template."

    # ---- copiar makefile ----
    if [ -f "templates/makefile" ]; then
        cp "templates/makefile" "$mf_target" \
            || error "Erro ao copiar makefile."
    else
        error "Template de makefile 'templates/makefile' não encontrado."
    fi

    success "Documento criado com sucesso!"
    printf "📄 Arquivo: %s\n" "$tex_target"
    printf "📝 makefile criado: %s\n" "$mf_target"
}

# -------------- comando: help ----------------
cmd_help() {
cat <<EOF
Arcabouço Manager — arc

Uso:
  arc <comando> [parametros]

Comandos:
  new <template>  <path>  Cria nova pasta com main.tex e makefile
  help                    Mostra esta ajuda

EOF
}

# ---------------- dispatcher -----------------
command="$1"
shift 1

case "$command" in
    new)       cmd_new "$@" ;;
    help|"")  cmd_help ;;
    *)
        echo "Comando desconhecido: $command"
        echo "Use: arc help"
        exit 1
        ;;
esac
