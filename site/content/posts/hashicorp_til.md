+++
title = "Today I Learned: ASDF_HASHICORP_OVERWRITE_ARCH" 
description = "The m1 mac has made me deal with a lot of processing architecture issues that never came up in the past" 
date = "2021-09-18" 
author = "Rodney Perez" 
+++

# ASDF_HASHICORP_OVERWRITE_ARCH

I usually never have to think about which processing architecture my computer uses. This changed when I recently received an M1 macbook from my work. I use asdf to install and switch between terraform versions. I went to work on an older piece of terraform. 

I go to run `asdf install terraform 0.12.27` 
and get 
```
Downloading terraform version 0.12.27 from https://releases.hashicorp.com/terraform/0.12.27/terraform_0.12.27_darwin_arm.zip
Error: terraform version 0.12.27 not found
```

Thanks to this [post](https://www.gitmemory.com/issue/asdf-community/asdf-hashicorp/34/854337903)  
 
I learned that asdf was misidentifying the processing architecture
by setting it like so:
`ASDF_HASHICORP_OVERWRITE_ARCH=amd64`

resolves the issue. Thanks radditude!
