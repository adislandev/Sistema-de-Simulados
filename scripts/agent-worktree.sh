#!/usr/bin/env bash
# Implementação prática da Regra 18 do AGENT-WORKFLOW.md — ver AGENT-WORKTREES.md.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPO_NAME="$(basename "$REPO_ROOT")"
WORKTREES_DIR="$(cd "$REPO_ROOT/.." && pwd)/${REPO_NAME}-worktrees"
LOCAL_CONFIG="$REPO_ROOT/.agent-workflow.local"

usage() {
  cat <<EOF
Uso:
  agent-worktree.sh start <task-id> --base <branch-base>
  agent-worktree.sh start <task-id> --from <branch-existente>
  agent-worktree.sh list
  agent-worktree.sh finish <task-id> [--delete-branch]
  agent-worktree.sh prune
EOF
}

# Aceita apenas ids/branches em formato seguro (evita path traversal no diretório do worktree).
validate_task_id() {
  local id="$1"
  if [[ -z "$id" || "$id" == *"/"* || "$id" == *".."* ]]; then
    echo "Erro: <task-id> inválido: '$id'." >&2
    exit 1
  fi
}

resolve_base_branch() {
  local cli_base="$1"
  if [ -n "$cli_base" ]; then
    printf '%s' "$cli_base"
    return
  fi
  if [ -f "$LOCAL_CONFIG" ]; then
    local cfg_base
    cfg_base=$(grep -E '^BASE_BRANCH=' "$LOCAL_CONFIG" | head -1 | cut -d= -f2-)
    if [ -n "$cfg_base" ]; then
      printf '%s' "$cfg_base"
      return
    fi
  fi
  printf ''
}

branch_exists() {
  local branch="$1"
  git -C "$REPO_ROOT" show-ref --verify --quiet "refs/heads/$branch" \
    || git -C "$REPO_ROOT" show-ref --verify --quiet "refs/remotes/origin/$branch"
}

cmd_start() {
  local task_id="${1:-}"; shift || true
  local base=""
  local from=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --base) base="$2"; shift 2 ;;
      --from) from="$2"; shift 2 ;;
      *) echo "Erro: argumento desconhecido: $1" >&2; exit 1 ;;
    esac
  done

  if [ -z "$task_id" ]; then
    echo "Erro: informe o <task-id>." >&2
    usage >&2
    exit 1
  fi
  validate_task_id "$task_id"

  local target_dir="$WORKTREES_DIR/$task_id"
  if [ -e "$target_dir" ]; then
    echo "Erro: já existe um diretório em $target_dir." >&2
    exit 1
  fi
  mkdir -p "$WORKTREES_DIR"

  if [ -n "$from" ]; then
    if ! branch_exists "$from"; then
      echo "Erro: branch '$from' não encontrada (local nem em origin)." >&2
      exit 1
    fi
    # git worktree add recusa nativamente se a branch já estiver em uso por outro worktree.
    git -C "$REPO_ROOT" worktree add "$target_dir" "$from"
    echo "Worktree retomado em: $target_dir (branch: $from)"
    return
  fi

  base="$(resolve_base_branch "$base")"
  if [ -z "$base" ]; then
    echo "Erro: nenhuma branch base informada." >&2
    echo "Use --base <branch-base> ou crie .agent-workflow.local com BASE_BRANCH=<branch>." >&2
    echo "Ver Regra 17 do docs/processo/AGENT-WORKFLOW.md: nunca presumir a branch base." >&2
    exit 1
  fi
  if ! branch_exists "$base"; then
    echo "Erro: branch base '$base' não encontrada (local nem em origin)." >&2
    exit 1
  fi

  git -C "$REPO_ROOT" worktree add -b "$task_id" "$target_dir" "$base"
  echo "Worktree criado em: $target_dir (branch: $task_id, base: $base)"
}

cmd_list() {
  git -C "$REPO_ROOT" worktree list
}

cmd_finish() {
  local task_id="${1:-}"; shift || true
  local delete_branch=false
  while [ $# -gt 0 ]; do
    case "$1" in
      --delete-branch) delete_branch=true; shift ;;
      *) echo "Erro: argumento desconhecido: $1" >&2; exit 1 ;;
    esac
  done

  if [ -z "$task_id" ]; then
    echo "Erro: informe o <task-id>." >&2
    usage >&2
    exit 1
  fi
  validate_task_id "$task_id"

  local target_dir="$WORKTREES_DIR/$task_id"

  if [ ! -e "$target_dir" ]; then
    echo "Erro: worktree não encontrado em $target_dir." >&2
    exit 1
  fi

  local resolved_target
  resolved_target="$(cd "$target_dir" && pwd)"
  if [ "$resolved_target" = "$REPO_ROOT" ]; then
    echo "Erro: não é permitido finalizar o worktree principal do repositório." >&2
    exit 1
  fi

  # git worktree remove recusa nativamente se houver alterações não commitadas.
  git -C "$REPO_ROOT" worktree remove "$target_dir"
  echo "Worktree removido: $target_dir"

  if [ "$delete_branch" = true ]; then
    git -C "$REPO_ROOT" branch -d "$task_id"
    echo "Branch '$task_id' apagada (somente porque já estava mesclada)."
  fi
}

cmd_prune() {
  git -C "$REPO_ROOT" worktree prune -v
}

main() {
  local sub="${1:-}"
  [ $# -gt 0 ] && shift
  case "$sub" in
    start) cmd_start "$@" ;;
    list) cmd_list "$@" ;;
    finish) cmd_finish "$@" ;;
    prune) cmd_prune "$@" ;;
    *) usage; exit 1 ;;
  esac
}

main "$@"
