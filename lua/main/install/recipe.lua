local v = require 'vim'
local sed = require 'lib.os_bin'.sed
local executable = require 'vim.executable'.executable
local file_readable = require 'vim.file_readable'.file_readable
local options = require 'user'.settings.install_options
local expand = v.fn.expand
local system = v.fn.system
return {
    {
        name = 'make-dirs',
        command = 'mkdir -p ~/.vim ~/.vim/tmp ~/.vim/bin/llvm ~/.vim/undo ~/.vim/nundo ~/.config/coc ~/.cache'
    },
    {
        name = 'apt-update',
        command = 'sudo apt update',
        os = 'Linux',
    },
    {
        name = 'install-brew',
        command = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" ; brew update',
        cond = not executable('brew'),
        os = 'Darwin',
    },
    {
        name = 'install-git',
        command = 'brew install git || true',
        os = 'Darwin'
    },
    {
        name = 'install-basic',
        command = 'brew install curl ag ctags cscope llvm make autoconf automake' ..
                  ' pkg-config python3 nodejs gnu-sed bat ripgrep lazygit tig golang pandoc || true',
        'brew install git || true',
        os = 'Darwin',
    },
    {
        name = 'rm-2to3-workaround',
        command = 'rm -rf /usr/local/bin/2to3',
        os = 'Darwin',
    },
    {
        name = 'link-python3',
        command = 'brew link python3',
        os = 'Darwin',
    },
    {
        name = 'tap-openjdk',
        command = 'brew tap AdoptOpenJDK/openjdk',
        os = 'Darwin',
    },
    {
        name = 'install-openjdk',
        command = 'brew install --cask adoptopenjdk/openjdk/adoptopenjdk8',
        os = 'Darwin',
    },
    {
        name = 'download-get-pip',
        command = 'curl https://bootstrap.pypa.io/get-pip.py -o ~/.vim/tmp/get-pip.py',
        os = 'Darwin',
    },
    {
        name = 'run-get-pip',
        command = 'python3 ~/.vim/tmp/get-pip.py',
        os = 'Darwin',
    },
    {
        name = 'path-clangd',
        command = 'echo export PATH=\\$PATH:/usr/local/opt/llvm/bin >> ~/.bashrc',
        condition = not executable('clangd') and executable('/usr/local/opt/llvm/bin/clangd'),
        os = 'Darwin',
    },
    {
        name = 'lazygit',
        command = [=[ LAZYGIT_VERSION=`curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" ]=] ..
                  [=[ | grep -Po '"tag_name": "v\K[^"]*'`; ]=] ..
                  [=[ curl -fLo ~/.vim/tmp/lazygit-install/lazygit.tar.gz --create-dirs ]=] ..
                  [=[ "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"; ]=] ..
                  [=[ cd ~/.vim/tmp/lazygit-install; ]=] ..
                  [=[ tar xf lazygit.tar.gz lazygit; ]=] ..
                  [=[ sudo install lazygit /usr/local/bin ]=],
        os = 'Linux',
    },
    {
        name = 'node-install',
        command = 'curl -sL https://deb.nodesource.com/setup_lts.x | bash -',
        os = 'Linux',
    },
    {
        name = 'llvm-install',
        command = 'curl -fLo ~/.vim/tmp/llvm-install/llvm.sh --create-dirs ' ..
                  'https://apt.llvm.org/llvm.sh ; ' ..
                  'cd ~/.vim/tmp/llvm-install ; chmod +x ./llvm.sh; ' ..
                  'sudo ./llvm.sh ' .. options.clang_version .. ' all',
        os = 'Linux',
    },
    {
        name = 'install-basic',
        command = 'sudo DEBIAN_FRONTEND=noninteractive apt install -y curl exuberant-ctags cscope git ' ..
                  'make autoconf automake pkg-config openjdk-8-jre python3 python3-pip gdb golang nodejs tig',
        os = 'Linux',
    },
    {
        name = 'link-clangd',
        command = 'rm -rf ~/.vim/bin/llvm/clangd && ln -s $(command -v clangd-' .. options.clang_version .. ') ~/.vim/bin/llvm/clangd',
        os = 'Linux',
    },
    {
        name = 'pip-install-pip-wheel',
        command = 'python3 -m pip install --upgrade pip wheel',
    },
    {
        name = 'pip-install-setuptools',
        command = 'python3 -m pip install setuptools',
    },
    {
        name = 'pip-install-pylint-compiledb-jedi',
        command = 'python3 -m pip install pylint compiledb jedi',
    },
    {
        name = 'download-opengrok',
        command = 'curl -fLo ~/.vim/bin/opengrok.tar.gz --create-dirs ' ..
                  'https://github.com/oracle/opengrok/releases/download/1.0/opengrok-1.0.tar.gz',
        cond = not file_readable(expand '~/.vim/bin/opengrok/lib/opengrok.jar')
    },
    {
        name = 'unpack-opengrok',
        command = 'cd ~/.vim/bin; tar -xzvf opengrok.tar.gz',
        cond = not file_readable(expand '~/.vim/bin/opengrok/lib/opengrok.jar')
    },
    {
        name = 'remove-opengrok-archive',
        command = 'rm ~/.vim/bin/opengrok.tar.gz',
        cond = not file_readable(expand '~/.vim/bin/opengrok/lib/opengrok.jar')
    },
    {
        name = 'rename-opengrok',
        command = 'mv ~/.vim/bin/opengrok* ~/.vim/bin/opengrok',
        cond = not file_readable(expand '~/.vim/bin/opengrok/lib/opengrok.jar')
    },
    {
        name = 'universal-ctags',
        command = 'cd ~/.vim/tmp; git clone https://github.com/universal-ctags/ctags.git; ' ..
                  'cd ./ctags; ./autogen.sh; ./configure; make -j; sudo make install',
        cond = not file_readable(expand '~/.vim/bin/ctags/Makefile')
    },
    {
        name = 'download-exuberant-ctags',
        command = 'curl -fLo ~/.vim/bin/ctags-exuberant/ctags.tar.gz --create-dirs ' ..
                  'http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz',
        cond = not executable 'ctags-exuberant' ,
    },
    {
        name = 'unpack-exuberant-ctags',
        command = 'cd ~/.vim/bin/ctags-exuberant; tar -xzvf ctags.tar.gz',
        cond = not executable 'ctags-exuberant' ,
    },
    {
        name = 'cleanup-exuberant-ctags',
        command = 'rm -rf ~/.vim/bin/ctags-exuberant/ctags',
        cond = not executable 'ctags-exuberant' ,
    },
    {
        name = 'rename-exuberant-ctags',
        command = 'mv ~/.vim/bin/ctags-exuberant/ctags-5.8 ~/.vim/bin/ctags-exuberant/ctags',
        cond = not executable 'ctags-exuberant' ,
    },
    {
        name = 'make-exuberant-ctags',
        command = [=[ cd ~/.vim/bin/ctags-exuberant/ctags; ]=] .. sed ..
                  [=[ -i 's@# define __unused__  _.*@#define __unused__@g' ./general.h; ./configure; make -j ]=],
        cond = not executable 'ctags-exuberant',
    },
    {
        name = 'install-bat',
        command = 'sudo DEBIAN_FRONTEND=noninteractive apt install -y bat',
        cond = function() return not executable 'bat' and system [=[ apt-cache search --names-only ^bat\$' ]=] ~= '' end,
        os = 'Linux',
    },
    {
        name = 'download-install-bat',
        command = 'curl -fLo ~/.vim/tmp/bat --create-dirs ' ..
                  'https://github.com/sharkdp/bat/releases/download/v0.15.1/bat_0.15.1_amd64.deb && ' ..
                  'sudo dpkg -i ~/.vim/tmp/bat',
        cond = function() return not executable 'bat' and system [=[ apt-cache search --names-only ^bat\$' ]=] == '' end,
        os = 'Linux',
    },
    {
        name = 'download-install-ripgrep',
        command = 'curl -fLo ~/.vim/tmp/ripgrep --create-dirs ' ..
                  'https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb ; ' ..
                  'sudo dpkg -i ~/.vim/tmp/ripgrep',
        cond = not executable 'rg',
        os = 'Linux',
    },
    {
        name = 'download-install-pandoc',
        command = 'curl -fLo ~/.vim/tmp/pandoc.deb --create-dirs ' ..
                  'https://github.com/jgm/pandoc/releases/download/2.10.1/pandoc-2.10.1-1-amd64.deb ; ' ..
                  'sudo dpkg -i ~/.vim/tmp/pandoc.deb',
        cond = not file_readable(expand '~/.vim/tmp/pandoc.deb'),
        os = 'Linux',
    },
    {
        name = 'configure-lazygit',
        command = [=[ mkdir -p ~/Library/Application\ Support/jesseduffield/lazygit ; ]=] ..
                  [=[ echo 'startuppopupversion: 1' > ~/Library/Application\ Support/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo 'gui: ' >> ~/Library/Application\ Support/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '  theme: ' >> ~/Library/Application\ Support/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '    selectedLineBgColor: ' >> ~/Library/Application\ Support/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '      - reverse' >> ~/Library/Application\ Support/jesseduffield/lazygit/config.yml ]=],
        os = 'Darwin',
    },
    {
        name = 'configure-lazygit',
        command = [=[ mkdir -p ~/.config/jesseduffield/lazygit ; ]=] ..
                  [=[ echo 'startuppopupversion: 1' > ~/.config/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo 'gui: ' >> ~/.config/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '  theme: ' >> ~/.config/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '    selectedLineBgColor: ' >> ~~/.config/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '      - reverse' >> ~/.config/jesseduffield/lazygit/config.yml ]=],
        os = 'Linux',
    },
    {
        name = 'vim-color',
        command = 'echo tokyonight > ~/.vim/.color',
        cond = not file_readable(expand '~/.vim/.color')
    },
    {
        name = 'pynvim',
        command = 'python3 -m pip install --user --upgrade pynvim',
    },
    {
        name = 'success',
        command = 'echo Installation complete!'
    },
}
