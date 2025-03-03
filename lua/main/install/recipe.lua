local v = require 'vim'
local sed = require 'lib.os_bin'.sed
local executable = require 'vim.executable'.executable
local file_readable = require 'vim.file_readable'.file_readable
local options = require 'user'.settings.install_options

local expand = v.fn.expand
local stdpath = v.fn.stdpath
local system = v.fn.system

local data_path = stdpath 'data'
local installation_path = data_path .. '/installation'
local bin_path = installation_path .. '/bin'
local programs_path = bin_path .. '/programs'
local misc_path = installation_path .. '/misc'
local undo_path = installation_path .. '/undo'

return {
    {
        name = 'make-dirs',
        command = 'mkdir -p ~/.config/coc ~/.cache ' ..
                  installation_path .. ' ' .. bin_path .. ' ' .. programs_path .. ' ' .. misc_path .. ' ' .. undo_path
    },
    {
        name = 'apt-software-properties-common',
        command = 'sudo DEBIAN_FRONTEND=noninteractive apt install -y software-properties-common',
        os = 'Linux',
    },
    {
        name = 'apt-add-repository-git',
        command = 'sudo DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:git-core/ppa',
        os = 'Linux',
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
        command = 'brew install curl ctags cscope llvm make autoconf automake unzip' ..
                  ' pkg-config python3 nodejs gnu-sed bat ripgrep lazygit tig pandoc plantuml || true',
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
        name = 'openjdk-install',
        command = 'brew install openjdk@17',
        os = 'Darwin',
    },
    {
        name = 'java-link',
        command = 'rm -rf ' .. programs_path .. '/java' ..
               ' ; ln -s /opt/homebrew/opt/java/bin/java ' .. programs_path .. '/java',
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
        name = 'clangd-link',
        command = 'rm -rf ' .. programs_path .. '/clangd' ..
               ' ; ln -s /opt/homebrew/opt/llvm/bin/clangd ' .. programs_path .. '/clangd',
        cond = file_readable '/opt/homebrew/opt/llvm/bin/clangd',
        os = 'Darwin'
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
        name = 'install-basic',
        command = 'sudo DEBIAN_FRONTEND=noninteractive apt install -y wget curl exuberant-ctags cscope git unzip ca-certificates gnupg bat ripgrep ' ..
                  'make autoconf xz-utils automake pkg-config openjdk-17-jre python3 python3-pip python3-venv gdb tig language-pack-en plantuml pandoc',
        os = 'Linux',
    },
    {
        name = 'llvm-install',
        command = 'curl -fLo ' .. misc_path .. '/llvm-install/llvm.sh --create-dirs ' ..
                  'https://apt.llvm.org/llvm.sh ; ' ..
                  'cd ' .. misc_path .. '/llvm-install ; chmod +x ./llvm.sh; ' ..
                  [=[ echo '\n' | sudo DEBIAN_FRONTEND=noninteractive ./llvm.sh ]=] .. options.clang_version .. ' all',
        os = 'Linux',
    },
    {
        name = 'node-install',
        command = [=[ sudo mkdir -p /etc/apt/keyrings ; ]=] ..
                  [=[ curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg ; ]=] ..
                  [=[ echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list ; ]=] ..
                  [=[ sudo apt update ; ]=] ..
                  [=[ sudo DEBIAN_FRONTEND=noninteractive apt install -y nodejs ]=],
        os = 'Linux',
    },
    {
        name = 'clangd-link',
        command = 'rm -rf ' .. programs_path .. '/clangd && ln -s $(command -v clangd-' .. options.clang_version .. ') ' .. programs_path .. '/clangd',
        os = 'Linux',
    },
    {
        name = 'python-extenlly-managed',
        command = 'sudo rm -rf /usr/lib/python*/EXTERNALLY-MANAGED || true',
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
        name = 'pip-install-compiledb',
        command = 'python3 -m pip install compiledb',
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
        os = 'Linux',
    },
    {
        name = 'exuberant-ctags-download',
        command = 'rm -rf ' .. bin_path .. '/ctags-exuberant ; ' ..
                  'curl -fLo ' .. bin_path .. '/ctags-exuberant/ctags.tar.gz --create-dirs ' ..
                  'http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz',
        cond = function() return not executable 'ctags-exuberant' end
    },
    {
        name = 'exuberant-ctags-unpack',
        command = 'cd ' .. bin_path .. '/ctags-exuberant; tar -xzvf ctags.tar.gz',
        cond = function() return not executable 'ctags-exuberant' end
    },
    {
        name = 'exuberant-ctags-cleanup',
        command = 'rm -rf ' .. bin_path .. '/ctags-exuberant/ctags',
        cond = function() return not executable 'ctags-exuberant' end
    },
    {
        name = 'exuberant-ctags-rename',
        command = 'mv ' .. bin_path .. '/ctags-exuberant/ctags-5.8 ' .. bin_path .. '/ctags-exuberant/ctags',
        cond = function() return not executable 'ctags-exuberant' end
    },
    {
        name = 'exuberant-ctags-make',
        command = [=[ cd ]=] .. bin_path .. [=[/ctags-exuberant/ctags; ]=] .. sed ..
                  [=[ -i 's@# define __unused__  _.*@#define __unused__@g' ./general.h; ./configure; make -j ]=],
        cond = function() return not executable 'ctags-exuberant' end
    },
    {
        name = 'exuberant-ctags-link',
        command = 'rm -rf ' .. bin_path .. '/ctags-exuberant' .. ' ; ' ..
                  'mkdir -p ' .. bin_path .. '/ctags-exuberant/ctags ; ' ..
                  'ln -s `which ctags-exuberant` ' .. bin_path .. '/ctags-exuberant/ctags/ctags',
        cond = function() return executable 'ctags-exuberant' end,
    },
    {
        name = 'install-bat',
        command = 'sudo DEBIAN_FRONTEND=noninteractive apt install -y bat',
        cond = function() return not executable 'bat' and system [=[ apt-cache search --names-only ^bat\$' ]=] ~= '' end,
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
        name = 'fzf-install',
        command = [=[ git clone https://github.com/junegunn/fzf.git ~/.fzf && ]=] ..
                  [=[ ~/.fzf/install --all ]=],
        cond = not file_readable(expand '~/.fzf/install'),
    },
    {
        name = 'pynvim',
        command = 'python3 -m pip install --user --upgrade pynvim',
    },
    {
        name = 'coc-settings',
        command = 'rm -rf ' .. stdpath('config') .. '/coc-settings.json ; ' .. "printf '" ..
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
            '    "diagnostic.virtualTextFormat": "%%message ",\n' ..
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
