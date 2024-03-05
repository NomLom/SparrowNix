let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHPGv0OMQEhGSTF27nGjyGCKFZq5E35U1IYRvCMo0IX";
in {
  "git_user.age".publicKeys = [user1];
  "git_email.age".publicKeys = [user1];
  # Add as many secrets as needed, all using user1's public key for encryption
}
