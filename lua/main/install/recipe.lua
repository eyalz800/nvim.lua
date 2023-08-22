local v = require 'vim'
local sed = require 'lib.os_bin'.sed
local executable = require 'vim.executable'.executable
local file_readable = require 'vim.file_readable'.file_readable
local options = require 'user'.settings.install_options

local stdpath = v.fn.stdpath
local expand = v.fn.expand
local system = v.fn.system

local data_path = stdpath 'data'
local installation_path = data_path .. '/installation'
local bin_path = installation_path .. '/bin'
local llvm_path = bin_path .. '/llvm'
local misc_path = installation_path .. '/misc'
local undo_path = installation_path .. '/undo'

return {
    {
        name = 'make-dirs',
        command = 'mkdir -p ~/.config/coc ~/.cache ' ..
                  installation_path .. ' ' .. bin_path .. ' ' .. llvm_path .. ' ' .. misc_path .. ' ' .. undo_path
    },
    {
        name = 'apt-update',
        command = 'sudo apt update',
        os = 'Linux',
    },
    {
        name = 'brew-install',
        command = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" ; brew update',
        cond = not executable('brew'),
        os = 'Darwin',
    },
    {
        name = 'git-install',
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
        name = 'python3-link',
        command = 'brew link python3',
        os = 'Darwin',
    },
    {
        name = 'openjdk-tap',
        command = 'brew tap AdoptOpenJDK/openjdk',
        os = 'Darwin',
    },
    {
        name = 'openjdk-install',
        command = 'brew install --cask adoptopenjdk/openjdk/adoptopenjdk8',
        os = 'Darwin',
    },
    {
        name = 'get-pip-download',
        command = 'curl https://bootstrap.pypa.io/get-pip.py -o ' .. misc_path .. '/get-pip.py',
        os = 'Darwin',
    },
    {
        name = 'get-pip-run',
        command = 'python3 ' .. misc_path .. '/get-pip.py',
        os = 'Darwin',
    },
    {
        name = 'clangd-path',
        command = 'echo export PATH=\\$PATH:/usr/local/opt/llvm/bin >> ~/.bashrc',
        condition = not executable('clangd') and executable('/usr/local/opt/llvm/bin/clangd'),
        os = 'Darwin',
    },
    {
        name = 'lazygit',
        command = [=[ LAZYGIT_VERSION=`curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" ]=] ..
                  [=[ | grep -Po '"tag_name": "v\K[^"]*'`; ]=] ..
                  [=[ curl -fLo ]=] .. misc_path .. [=[/lazygit-install/lazygit.tar.gz --create-dirs ]=] ..
                  [=[ "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"; ]=] ..
                  [=[ cd ]=] .. misc_path .. [=[/lazygit-install; ]=] ..
                  [=[ tar xf lazygit.tar.gz lazygit; ]=] ..
                  [=[ sudo install lazygit /usr/local/bin ]=],
        os = 'Linux',
    },
    {
        name = 'node-install',
        command = 'curl -sL https://deb.nodesource.com/setup_lts.x | sudo bash -',
        os = 'Linux',
    },
    {
        name = 'llvm-install',
        command = 'curl -fLo ' .. misc_path .. '/llvm-install/llvm.sh --create-dirs ' ..
                  'https://apt.llvm.org/llvm.sh ; ' ..
                  'cd ' .. misc_path .. '/llvm-install ; chmod +x ./llvm.sh; ' ..
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
        name = 'clangd-link',
        command = 'rm -rf ' .. bin_path .. '/llvm/clangd && ln -s $(command -v clangd-' .. options.clang_version .. ') ' .. bin_path .. '/llvm/clangd',
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
        command = 'curl -fLo ' .. bin_path .. '/opengrok.tar.gz --create-dirs ' ..
                  'https://github.com/oracle/opengrok/releases/download/1.0/opengrok-1.0.tar.gz',
        cond = not file_readable(bin_path .. '/opengrok/lib/opengrok.jar')
    },
    {
        name = 'unpack-opengrok',
        command = 'cd ' .. bin_path .. '; tar -xzvf opengrok.tar.gz',
        cond = not file_readable(bin_path .. '/opengrok/lib/opengrok.jar')
    },
    {
        name = 'remove-opengrok-archive',
        command = 'rm ' .. bin_path .. '/opengrok.tar.gz',
        cond = not file_readable(bin_path .. '/opengrok/lib/opengrok.jar')
    },
    {
        name = 'rename-opengrok',
        command = 'mv ' .. bin_path .. '/opengrok* ' .. bin_path .. '/opengrok',
        cond = not file_readable(bin_path .. '/opengrok/lib/opengrok.jar')
    },
    {
        name = 'universal-ctags',
        command = 'cd ' .. misc_path .. '; rm -rf ctags; git clone https://github.com/universal-ctags/ctags.git; ' ..
                  'cd ./ctags; ./autogen.sh; ./configure; make -j; sudo make install',
    },
    {
        name = 'exuberant-ctags-download',
        command = 'curl -fLo ' .. bin_path .. '/ctags-exuberant/ctags.tar.gz --create-dirs ' ..
                  'http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz',
        cond = not executable 'ctags-exuberant' ,
    },
    {
        name = 'exuberant-ctags-unpack',
        command = 'cd ' .. bin_path .. '/ctags-exuberant; tar -xzvf ctags.tar.gz',
        cond = not executable 'ctags-exuberant' ,
    },
    {
        name = 'exuberant-ctags-cleanup',
        command = 'rm -rf ' .. bin_path .. '/ctags-exuberant/ctags',
        cond = not executable 'ctags-exuberant' ,
    },
    {
        name = 'exuberant-ctags-rename',
        command = 'mv ' .. bin_path .. '/ctags-exuberant/ctags-5.8 ' .. bin_path .. '/ctags-exuberant/ctags',
        cond = not executable 'ctags-exuberant' ,
    },
    {
        name = 'exuberant-ctags-make',
        command = [=[ cd ]=] .. bin_path .. [=[/ctags-exuberant/ctags; ]=] .. sed ..
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
        command = 'curl -fLo ' .. misc_path .. '/bat --create-dirs ' ..
                  'https://github.com/sharkdp/bat/releases/download/v0.15.1/bat_0.15.1_amd64.deb && ' ..
                  'sudo dpkg -i ' .. misc_path .. '/bat',
        cond = function() return not executable 'bat' and system [=[ apt-cache search --names-only ^bat\$' ]=] == '' end,
        os = 'Linux',
    },
    {
        name = 'download-install-ripgrep',
        command = 'curl -fLo ' .. misc_path .. '/ripgrep --create-dirs ' ..
                  'https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb ; ' ..
                  'sudo dpkg -i ' .. misc_path .. '/ripgrep',
        cond = not executable 'rg',
        os = 'Linux',
    },
    {
        name = 'download-install-pandoc',
        command = 'curl -fLo ' .. misc_path .. '/pandoc.deb --create-dirs ' ..
                  'https://github.com/jgm/pandoc/releases/download/2.10.1/pandoc-2.10.1-1-amd64.deb ; ' ..
                  'sudo dpkg -i ' .. misc_path .. '/pandoc.deb',
        cond = not file_readable(misc_path .. '/pandoc.deb'),
        os = 'Linux',
    },
    {
        name = 'lazygit-configure',
        command = [=[ mkdir -p ~/Library/Application\ Support/jesseduffield/lazygit ; ]=] ..
                  [=[ echo 'startuppopupversion: 1' > ~/Library/Application\ Support/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo 'gui: ' >> ~/Library/Application\ Support/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '  theme: ' >> ~/Library/Application\ Support/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '    selectedLineBgColor: ' >> ~/Library/Application\ Support/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '      - reverse' >> ~/Library/Application\ Support/jesseduffield/lazygit/config.yml ]=],
        os = 'Darwin',
    },
    {
        name = 'lazygit-configure',
        command = [=[ mkdir -p ~/.config/jesseduffield/lazygit ; ]=] ..
                  [=[ echo 'startuppopupversion: 1' > ~/.config/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo 'gui: ' >> ~/.config/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '  theme: ' >> ~/.config/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '    selectedLineBgColor: ' >> ~/.config/jesseduffield/lazygit/config.yml ; ]=] ..
                  [=[ echo '      - reverse' >> ~/.config/jesseduffield/lazygit/config.yml ]=],
        os = 'Linux',
    },
    {
        name = 'pynvim',
        command = 'python3 -m pip install --user --upgrade pynvim',
    },
    {
        name = 'coc-settings',
        command = 'rm -rf ' .. stdpath('config') .. '/coc-settings.json ; ' .. "echo -e '" ..
            '{\n' ..
            '    "clangd.semanticHighlighting": false,\n' ..
            '    "inlayHint.enable": false,\n' ..
            '    "coc.preferences.formatOnType": false,\n' ..
            '    "suggest.noselect": true,\n' ..
            '    "notification.disabledProgressSources": ["*"],\n' ..
            '    "suggest.floatConfig": {\n' ..
            '        "border": true,\n' ..
            '        "rounded": true,\n' ..
            '        "winblend": true\n' ..
            '    },\n' ..
            '    "suggest.pumFloatConfig": {\n' ..
            '        "border": true,\n' ..
            '        "rounded": true,\n' ..
            '        "winblend": true\n' ..
            '    },\n' ..
            '    "hover.floatConfig": {\n' ..
            '        "border": true,\n' ..
            '        "rounded": true,\n' ..
            '        "winblend": true\n' ..
            '    },\n' ..
            '    "diagnostic.floatConfig": {\n' ..
            '        "border": true,\n' ..
            '        "rounded": true,\n' ..
            '        "winblend": true\n' ..
            '    },\n' ..
            '    "diagnostic.enableSign": true,\n' ..
            '    "diagnostic.enableHighlightLineNumber": true,\n' ..
            '    "diagnostic.infoSign": "",\n' ..
            '    "diagnostic.hintSign": "󰌶",\n' ..
            '    "diagnostic.warningSign": "",\n' ..
            '    "diagnostic.errorSign": "",\n' ..
            '    "diagnostic.virtualText": true,\n' ..
            '    "diagnostic.virtualTextCurrentLineOnly": false,\n' ..
            '    "diagnostic.virtualTextFormat": "%message ",\n' ..
            '    "diagnostic.virtualTextPrefix": "■ ",\n' ..
            '    "cSpell.userWords": [\n' ..
            '        "GTEST",\n' ..
            '        "autodetect",\n' ..
            '        "noninteractive",\n' ..
            '        "println",\n' ..
            '        "pugi",\n' ..
            '        "pugixml",\n' ..
            '        "sfml",\n' ..
            '        "stdm",\n' ..
            '        "stoi",\n' ..
            '        "winblend",\n' ..
            '        "vformat"\n' ..
            '    ]\n' ..
            '}\' > ' .. stdpath('config') .. '/coc-settings.json',
    },
    {
        name = 'success',
        command = 'echo Installation complete!'
    },
}
