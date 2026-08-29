#!/usr/bin/env bash
set -euo pipefail

build_cli() {
  local app_id="$1"
  local source_dir="$2"
  local main_class="$3"
  docker build \
    --file images/Dockerfile.cli \
    --build-arg "APP_ID=$app_id" \
    --build-arg "SOURCE_DIR=$source_dir" \
    --build-arg "MAIN_CLASS=$main_class" \
    --tag "portfolio-demo-test:$app_id" .
}

build_cli make-change upstream/make-change com.skilldistillery.makechange.MakeChangeApp
make_change_output="$(printf '10\n20\n' | docker run --rm --entrypoint java portfolio-demo-test:make-change -jar /app/demo.jar)"
grep -Fq 'change' <<<"${make_change_output,,}"

build_cli jets upstream/jets com.skilldistillery.jets.JestApplication
jets_output="$(printf '10\n' | docker run --rm --entrypoint java portfolio-demo-test:jets -jar /app/demo.jar)"
grep -Fq 'jet' <<<"${jets_output,,}"

build_cli blackjack upstream/blackjack com.skilldistillery.cards.blackjack.BlackjackApp
blackjack_output="$(printf 'Demo Player\n1\n5\n0\n5\n3\n' | timeout 15 docker run --rm --entrypoint java portfolio-demo-test:blackjack -jar /app/demo.jar || true)"
grep -Fq 'blackjack' <<<"${blackjack_output,,}"

docker build --file images/Dockerfile.film-query --tag portfolio-demo-test:film-query .

