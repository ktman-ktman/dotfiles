fish_vi_key_bindings

# poetry
if test -d /opt/poetry/bin
    set -x PATH $PATH /opt/poetry/bin
end

# rye
if test -d ~/.rye
    set -x PATH $PATH ~/.rye/shims/rye
end

# juliaup
if test -d ~/.juliaup
    set -x PATH $PATH ~/.juliaup/bin/juliaup
end
