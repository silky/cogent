(*
 * Copyright 2016, NICTA
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(NICTA_GPL)
 *)

theory COGENT_C_Val_Auto
imports 
 Value_Relation_Generation
 Type_Relation_Generation
begin

ML{* fun local_setup_val_rel_type_rel_put_them_in_buckets file_nm ctxt = 
(* local_setup_val_rel_type_rel defines and registers all the necessary val_rels and type_rels.*)
 let
  fun val_rel_type_rel_def uval lthy = lthy |> type_rel_def file_nm uval |> val_rel_def file_nm uval;

  (* FIXME: This recursion is pretty bad, I think.*)
  fun local_setup_val_rel_type_rel' [] lthy = lthy
   |  local_setup_val_rel_type_rel' (uval::uvals) lthy = 
       local_setup_instantiation_definition_instance ([get_ty_nm_C uval],[],"cogent_C_val") 
       (val_rel_type_rel_def uval) (local_setup_val_rel_type_rel' uvals lthy);

  val thy = Proof_Context.theory_of ctxt;  

  val uvals' = read_table file_nm (Proof_Context.theory_of ctxt);
  val uvals = uvals' |> map (unify_usum_tys o unify_sigils) |> rm_redundancy |> rev |>
               get_uvals_for_which_ac_mk_st_info file_nm thy;

  val lthy' = local_setup_val_rel_type_rel' uvals ctxt;
 in
  lthy'
 end;
*}

end
