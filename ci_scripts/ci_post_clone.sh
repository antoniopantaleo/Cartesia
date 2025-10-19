#
//  ci_post_clone.sh
//  Cartesia
//
//  Created by Antonio on 19/10/25.
//

curl https://mise.run | MISE_VERSION=$(MISE_VERSION) sh
mise install
