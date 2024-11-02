_default:
  @just --list

build:
  whiskers wlogout.tera

icons:
  ./generate_icons.sh
