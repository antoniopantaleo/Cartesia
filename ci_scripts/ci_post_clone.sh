#
//  ci_post_clone.sh
//  Cartesia
//
//  Created by Antonio on 19/10/25.
//

curl https://mise.run | MISE_VERSION=$(MISE_VERSION) sh
echo "eval \"\$(/Users/local/.local/bin/mise activate zsh)\"" >> "/Users/local/.zshrc"
source /Users/local/.zshrc
mise settings experimental=true
mise install

tuist generate
