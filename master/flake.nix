{
  description = ''Cirru writer in Nim'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-cirru_writer-master.flake = false;
  inputs.src-cirru_writer-master.ref   = "refs/heads/master";
  inputs.src-cirru_writer-master.owner = "Cirru";
  inputs.src-cirru_writer-master.repo  = "writer.nim";
  inputs.src-cirru_writer-master.type  = "github";
  
  inputs."edn".owner = "nim-nix-pkgs";
  inputs."edn".ref   = "master";
  inputs."edn".repo  = "edn";
  inputs."edn".dir   = "0_2_3";
  inputs."edn".type  = "github";
  inputs."edn".inputs.nixpkgs.follows = "nixpkgs";
  inputs."edn".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-cirru_writer-master"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-cirru_writer-master";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}