(**************************************************************************)
(*                                                                        *)
(*                         OCaml Migrate Parsetree                        *)
(*                                                                        *)
(*                             Frédéric Bour                              *)
(*                   Jérémie Dimino, Jane Street Europe                   *)
(*                                                                        *)
(*   Copyright 2017 Institut National de Recherche en Informatique et     *)
(*     en Automatique (INRIA).                                            *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

(*$ #use "src/cinaps_helpers" $*)

(* Shared definitions.
   Mostly errors about features missing in older versions. *)
module Def = Migrate_parsetree_def

(* Copy of OCaml parsetrees *)
(*$foreach_version (fun suffix _ ->
     printf "module Ast_%s = Ast_%s\n" suffix suffix
  )*)
module Ast_402 = Ast_402
module Ast_403 = Ast_403
module Ast_404 = Ast_404
module Ast_405 = Ast_405
module Ast_406 = Ast_406
module Ast_407 = Ast_407
(*$*)

(* A module for marshalling/unmarshalling arbitrary versions of Asts *)
module Ast_io = Migrate_parsetree_ast_io

(* Manual migration between versions *)
(*$foreach_version_pair (fun x y ->
     printf "module Migrate_%s_%s = Migrate_parsetree_%s_%s\n" x y x y;
     printf "module Migrate_%s_%s = Migrate_parsetree_%s_%s\n" y x y x;
  )*)
module Migrate_402_403 = Migrate_parsetree_402_403
module Migrate_403_402 = Migrate_parsetree_403_402
module Migrate_403_404 = Migrate_parsetree_403_404
module Migrate_404_403 = Migrate_parsetree_404_403
module Migrate_404_405 = Migrate_parsetree_404_405
module Migrate_405_404 = Migrate_parsetree_405_404
module Migrate_405_406 = Migrate_parsetree_405_406
module Migrate_406_405 = Migrate_parsetree_406_405
module Migrate_406_407 = Migrate_parsetree_406_407
module Migrate_407_406 = Migrate_parsetree_407_406
(*$*)

(* An abstraction of OCaml compiler versions *)
module Versions = Migrate_parsetree_versions

(* All versions are compatible with this signature *)
module type OCaml_version = Versions.OCaml_version

(*$foreach_version (fun suffix _ ->
     printf "module OCaml_%s = Versions.OCaml_%s\n" suffix suffix
  )*)
module OCaml_402 = Versions.OCaml_402
module OCaml_403 = Versions.OCaml_403
module OCaml_404 = Versions.OCaml_404
module OCaml_405 = Versions.OCaml_405
module OCaml_406 = Versions.OCaml_406
module OCaml_407 = Versions.OCaml_407
(*$*)
module OCaml_current = Versions.OCaml_current

(* A Functor taking two OCaml versions and producing a module of functions
   migrating from one to the other. *)
module Convert = Versions.Convert

(* A [Parse] module that migrate ASTs to the desired version of an AST *)
module Parse = Migrate_parsetree_parse

(* Entrypoints for registering rewriters and making a ppx binary *)
module Driver = Migrate_parsetree_driver

(* Aliases for compiler-libs modules that might be shadowed *)
module Compiler_libs = struct
  module Location = Location
  module Longident = Longident

  module type Asttypes = module type of struct include Asttypes end
  module rec Asttypes : Asttypes = Asttypes

  module type Parsetree = module type of struct include Parsetree end
  module rec Parsetree : Parsetree = Parsetree

  module Docstrings = Docstrings
  module Ast_helper = Ast_helper
  module Ast_mapper = Ast_mapper
end
