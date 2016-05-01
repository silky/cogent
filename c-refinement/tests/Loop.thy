(*
 * Copyright 2016, NICTA
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(NICTA_GPL)
 *)

(*
 * Testcase for higher-order functions.
 *
 * Sources: loop.cogent loop.ac
 * To generate:
 *   cogent -gloopmain loop.cogent --infer-c-func=loop.ac --table-c-types=loopfull.table
 *   cat loopmain.c loop_pp_inferred.c > loopfull.c
 *   gcc loopfull.c -o loopfull -I../../cogent/lib && ./loopfull
 *   cogent --type-proof=Loop --fml-typing-tree loop.cogent
 *
 *
 * The loop combinator (seq32_0) is a second-order function.
 * In this program, it is called with id_loopbody and triangular_loopbody
 * as arguments.
 *
 * Logical call graph:
 *   triangular \<rightarrow> seq32_0 \<rightarrow> triangular_loopbody \<rightarrow> id_f \<rightarrow> seq32_0 \<rightarrow> id_loopbody
 *
 * C call graph:
 *   triangular \<rightarrow> seq32_0 \<rightarrow> dispatch_t2 \<rightarrow>
 *   triangular_loopbody \<rightarrow> id_f \<rightarrow> seq32_0 \<rightarrow> dispatch_t2 \<rightarrow> id_loopbody
 *
 * We verify the program in bottom-up order, starting with id_loopbody.
 * We first verify seq32_0 with dispatch_t2 specialised to id_loopbody,
 * which allows us to verify id_f and triangular_loopbody.
 * Then, we verify seq32_0 with dispatch_t2 specialised to triangular_loopbody,
 * which allows us to verify triangular.
 *)
theory Loop
imports
  "../COGENTHigherOrder"
  "../Corres_Tac"
  "../TypeProofGen"
  "../Type_Relation_Generation"
  "../Deep_Embedding_Auto"
  "../Tidy"
begin

(*
This file is generated by COGENT version 2.3.0.0-cee676104d
with command ./cogent --type-proof=Loop --fml-typing-tree loop.cogent
at Fri, 15 May 2015 17:30:31 AEST
*)

definition
  "abbreviatedType1 \<equiv> TRecord [(TPrim (Num U32), False), (TPrim (Num U32), False)] Unboxed"

lemmas abbreviated_type_defs =
  abbreviatedType1_def

definition
  "seq32_0_type \<equiv> ([], (TRecord [(TPrim (Num U32), False), (TPrim (Num U32), False), (TFun abbreviatedType1 (TPrim (Num U32)), False), (TPrim (Num U32), False)] Unboxed, TPrim (Num U32)))"

definition
  "id_loopbody_type \<equiv> ([], (abbreviatedType1, TPrim (Num U32)))"

definition
  "id_loopbody \<equiv> Take (Var 0) 0 (Take (Var 1) 1 (Let (Lit (LU8 1)) (Let (Cast U32 (Var 0)) (Prim (Plus U32) [Var 4, Var 0]))))"

definition
  "id_f_type \<equiv> ([], (TPrim (Num U32), TPrim (Num U32)))"

definition
  "id_f \<equiv> Let (Var 0) (Let (Lit (LU8 0)) (Let (Cast U32 (Var 0)) (Let (Fun id_loopbody []) (Let (Lit (LU8 0)) (Let (Cast U32 (Var 0)) (Let (Struct [TPrim (Num U32), TPrim (Num U32), TFun abbreviatedType1 (TPrim (Num U32)), TPrim (Num U32)] [Var 3, Var 5, Var 2, Var 0]) (App (AFun ''seq32_0'' []) (Var 0))))))))"

definition
  "triangular_loopbody_type \<equiv> ([], (abbreviatedType1, TPrim (Num U32)))"

definition
  "triangular_loopbody \<equiv> Take (Var 0) 0 (Take (Var 1) 1 (Let (App (Fun id_f []) (Var 0)) (Prim (Plus U32) [Var 3, Var 0])))"

definition
  "triangular_type \<equiv> ([], (TPrim (Num U32), TPrim (Num U32)))"

definition
  "triangular \<equiv> Let (Var 0) (Let (Lit (LU8 0)) (Let (Cast U32 (Var 0)) (Let (Fun triangular_loopbody []) (Let (Lit (LU8 0)) (Let (Cast U32 (Var 0)) (Let (Struct [TPrim (Num U32), TPrim (Num U32), TFun abbreviatedType1 (TPrim (Num U32)), TPrim (Num U32)] [Var 3, Var 5, Var 2, Var 0]) (App (AFun ''seq32_0'' []) (Var 0))))))))"

ML {*
val COGENT_functions = ["id_loopbody","id_f","triangular_loopbody","triangular"]
val COGENT_abstract_functions = ["seq32_0"]
*}

definition
  "\<Xi> func_name' \<equiv> case func_name' of ''seq32_0'' \<Rightarrow> seq32_0_type | ''id_loopbody'' \<Rightarrow> id_loopbody_type | ''id_f'' \<Rightarrow> id_f_type | ''triangular_loopbody'' \<Rightarrow> triangular_loopbody_type | ''triangular'' \<Rightarrow> triangular_type"

definition
  "\<xi> func_name' \<equiv> case func_name' of ''seq32_0'' \<Rightarrow> undefined"

definition
  "id_loopbody_typetree \<equiv> TyTrSplit (Cons (Some TSK_L) []) [] TyTrLeaf [Some (TPrim (Num U32)), Some (TRecord [(TPrim (Num U32), True), (TPrim (Num U32), False)] Unboxed)] (TyTrSplit (Cons None (Cons (Some TSK_L) (Cons None []))) [] TyTrLeaf [Some (TPrim (Num U32)), Some (TRecord [(TPrim (Num U32), True), (TPrim (Num U32), True)] Unboxed)] (TyTrSplit (Cons (Some TSK_L) (Cons (Some TSK_L) (append (replicate 3 None) []))) [] TyTrLeaf [Some (TPrim (Num U8))] (TyTrSplit (Cons (Some TSK_L) (append (replicate 5 None) [])) [] TyTrLeaf [Some (TPrim (Num U32))] TyTrLeaf)))"

definition
  "id_f_typetree \<equiv> TyTrSplit (Cons (Some TSK_L) []) [] TyTrLeaf [Some (TPrim (Num U32))] (TyTrSplit (append (replicate 2 None) []) [] TyTrLeaf [Some (TPrim (Num U8))] (TyTrSplit (Cons (Some TSK_L) (append (replicate 2 None) [])) [] TyTrLeaf [Some (TPrim (Num U32))] (TyTrSplit (append (replicate 4 None) []) [] TyTrLeaf [Some (TFun abbreviatedType1 (TPrim (Num U32)))] (TyTrSplit (append (replicate 5 None) []) [] TyTrLeaf [Some (TPrim (Num U8))] (TyTrSplit (Cons (Some TSK_L) (append (replicate 5 None) [])) [] TyTrLeaf [Some (TPrim (Num U32))] (TyTrSplit (Cons (Some TSK_L) (Cons None (Cons (Some TSK_L) (Cons (Some TSK_L) (Cons None (Cons (Some TSK_L) (Cons None []))))))) [] TyTrLeaf [Some (TRecord [(TPrim (Num U32), False), (TPrim (Num U32), False), (TFun abbreviatedType1 (TPrim (Num U32)), False), (TPrim (Num U32), False)] Unboxed)] TyTrLeaf))))))"

definition
  "triangular_loopbody_typetree \<equiv> TyTrSplit (Cons (Some TSK_L) []) [] TyTrLeaf [Some (TPrim (Num U32)), Some (TRecord [(TPrim (Num U32), True), (TPrim (Num U32), False)] Unboxed)] (TyTrSplit (Cons None (Cons (Some TSK_L) (Cons None []))) [] TyTrLeaf [Some (TPrim (Num U32)), Some (TRecord [(TPrim (Num U32), True), (TPrim (Num U32), True)] Unboxed)] (TyTrSplit (Cons (Some TSK_L) (Cons (Some TSK_L) (append (replicate 3 None) []))) [] TyTrLeaf [Some (TPrim (Num U32))] TyTrLeaf))"

definition
  "triangular_typetree \<equiv> TyTrSplit (Cons (Some TSK_L) []) [] TyTrLeaf [Some (TPrim (Num U32))] (TyTrSplit (append (replicate 2 None) []) [] TyTrLeaf [Some (TPrim (Num U8))] (TyTrSplit (Cons (Some TSK_L) (append (replicate 2 None) [])) [] TyTrLeaf [Some (TPrim (Num U32))] (TyTrSplit (append (replicate 4 None) []) [] TyTrLeaf [Some (TFun abbreviatedType1 (TPrim (Num U32)))] (TyTrSplit (append (replicate 5 None) []) [] TyTrLeaf [Some (TPrim (Num U8))] (TyTrSplit (Cons (Some TSK_L) (append (replicate 5 None) [])) [] TyTrLeaf [Some (TPrim (Num U32))] (TyTrSplit (Cons (Some TSK_L) (Cons None (Cons (Some TSK_L) (Cons (Some TSK_L) (Cons None (Cons (Some TSK_L) (Cons None []))))))) [] TyTrLeaf [Some (TRecord [(TPrim (Num U32), False), (TPrim (Num U32), False), (TFun abbreviatedType1 (TPrim (Num U32)), False), (TPrim (Num U32), False)] Unboxed)] TyTrLeaf))))))"

ML {* open TTyping_Tactics *}

ML_quiet {*
val typing_helper_1_script : tac list = [
(RTac @{thm kind_tprim})
] *}


lemma typing_helper_1[unfolded abbreviated_type_defs] :
  "kinding [] (TPrim (Num U32)) {E, S, D}"
  apply (unfold abbreviated_type_defs)?
  apply (tactic {* map (fn t => DETERM (interpret_tac t @{context} 1)) typing_helper_1_script |> EVERY *})
  done

ML_quiet {*
val typing_helper_2_script : tac list = [
(RTac @{thm kind_trec[where k = "{E,S,D}"]}),
(RTac @{thm kind_record_cons1}),
(RTac @{thm typing_helper_1}),
(RTac @{thm kind_record_cons1}),
(RTac @{thm typing_helper_1}),
(RTac @{thm kind_record_empty}),
(SimpTac ([],[]))
] *}


lemma typing_helper_2[unfolded abbreviated_type_defs] :
  "kinding [] abbreviatedType1 {E, S, D}"
  apply (unfold abbreviated_type_defs)?
  apply (tactic {* map (fn t => DETERM (interpret_tac t @{context} 1)) typing_helper_2_script |> EVERY *})
  done

ML_quiet {*
val typing_helper_3_script : tac list = [
(RTac @{thm kind_trec[where k = "{E,S,D}"]}),
(RTac @{thm kind_record_cons2}),
(RTac @{thm typing_helper_1}),
(RTac @{thm kind_record_cons1}),
(RTac @{thm typing_helper_1}),
(RTac @{thm kind_record_empty}),
(SimpTac ([],[]))
] *}


lemma typing_helper_3[unfolded abbreviated_type_defs] :
  "kinding [] (TRecord [(TPrim (Num U32), True), (TPrim (Num U32), False)] Unboxed) {E, S, D}"
  apply (unfold abbreviated_type_defs)?
  apply (tactic {* map (fn t => DETERM (interpret_tac t @{context} 1)) typing_helper_3_script |> EVERY *})
  done

ML_quiet {*
val typing_helper_4_script : tac list = [
(RTac @{thm kind_trec[where k = "{E,S,D}"]}),
(RTac @{thm kind_record_cons2}),
(RTac @{thm typing_helper_1}),
(RTac @{thm kind_record_cons2}),
(RTac @{thm typing_helper_1}),
(RTac @{thm kind_record_empty}),
(SimpTac ([],[]))
] *}


lemma typing_helper_4[unfolded abbreviated_type_defs] :
  "kinding [] (TRecord [(TPrim (Num U32), True), (TPrim (Num U32), True)] Unboxed) {E, S, D}"
  apply (unfold abbreviated_type_defs)?
  apply (tactic {* map (fn t => DETERM (interpret_tac t @{context} 1)) typing_helper_4_script |> EVERY *})
  done

ML_quiet {*
val typing_helper_5_script : tac list = [
(RTac @{thm kind_tprim[where k = "{E,S,D}"]})
] *}


lemma typing_helper_5[unfolded abbreviated_type_defs] :
  "kinding [] (TPrim (Num U8)) {E, S, D}"
  apply (unfold abbreviated_type_defs)?
  apply (tactic {* map (fn t => DETERM (interpret_tac t @{context} 1)) typing_helper_5_script |> EVERY *})
  done

ML_quiet {*
val typing_helper_6_script : tac list = [
(RTac @{thm kind_tfun[where k = "{E,S,D}"]}),
(RTac @{thm typing_helper_2}),
(RTac @{thm typing_helper_1})
] *}


lemma typing_helper_6[unfolded abbreviated_type_defs] :
  "kinding [] (TFun abbreviatedType1 (TPrim (Num U32))) {E, S, D}"
  apply (unfold abbreviated_type_defs)?
  apply (tactic {* map (fn t => DETERM (interpret_tac t @{context} 1)) typing_helper_6_script |> EVERY *})
  done

ML_quiet {*
val typing_helper_7_script : tac list = [
(SimpTac ([],[(nth @{thms HOL.simp_thms} (25-1)),(nth @{thms HOL.simp_thms} (26-1))]))
] *}


lemma typing_helper_7[unfolded abbreviated_type_defs] :
  "list_all2 (kinding []) [] []"
  apply (unfold abbreviated_type_defs)?
  apply (tactic {* map (fn t => DETERM (interpret_tac t @{context} 1)) typing_helper_7_script |> EVERY *})
  done

ML_quiet {*
val typing_helper_8_script : tac list = [
(RTac @{thm kind_trec[where k = "{E,S,D}"]}),
(RTac @{thm kind_record_cons1}),
(RTac @{thm typing_helper_1}),
(RTac @{thm kind_record_cons1}),
(RTac @{thm typing_helper_1}),
(RTac @{thm kind_record_cons1}),
(RTac @{thm typing_helper_6}),
(RTac @{thm kind_record_cons1}),
(RTac @{thm typing_helper_1}),
(RTac @{thm kind_record_empty}),
(SimpTac ([],[]))
] *}


lemma typing_helper_8[unfolded abbreviated_type_defs] :
  "kinding [] (TRecord [(TPrim (Num U32), False), (TPrim (Num U32), False), (TFun abbreviatedType1 (TPrim (Num U32)), False), (TPrim (Num U32), False)] Unboxed) {E, S, D}"
  apply (unfold abbreviated_type_defs)?
  apply (tactic {* map (fn t => DETERM (interpret_tac t @{context} 1)) typing_helper_8_script |> EVERY *})
  done

ML_quiet {*
val typing_helper_9_script : tac list = [
(RTac @{thm kind_tfun[where k = "{E,S,D}"]}),
(RTac @{thm typing_helper_8}),
(RTac @{thm typing_helper_1})
] *}


lemma typing_helper_9[unfolded abbreviated_type_defs] :
  "kinding [] (TFun (TRecord [(TPrim (Num U32), False), (TPrim (Num U32), False), (TFun abbreviatedType1 (TPrim (Num U32)), False), (TPrim (Num U32), False)] Unboxed) (TPrim (Num U32))) {E, S, D}"
  apply (unfold abbreviated_type_defs)?
  apply (tactic {* map (fn t => DETERM (interpret_tac t @{context} 1)) typing_helper_9_script |> EVERY *})
  done

ML_quiet {*
val id_loopbody_typecorrect_script : hints list = [
KindingTacs [(RTac @{thm typing_helper_2})],
KindingTacs [(RTac @{thm typing_helper_1})],
KindingTacs [(RTac @{thm typing_helper_3})],
TypingTacs [],
KindingTacs [(RTac @{thm typing_helper_1})],
KindingTacs [(RTac @{thm typing_helper_1})],
KindingTacs [(RTac @{thm typing_helper_4})],
TypingTacs [],
KindingTacs [(RTac @{thm typing_helper_1})],
KindingTacs [(RTac @{thm typing_helper_5})],
TypingTacs [(RTac @{thm typing_lit'}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [@{thm typing_helper_1},@{thm typing_helper_4}]),(SimpTac ([],[]))],
KindingTacs [(RTac @{thm typing_helper_1})],
TypingTacs [(RTac @{thm typing_cast}),(RTac @{thm typing_var}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [@{thm typing_helper_5}]),(SimpTac ([],[])),(SimpTac ([],[]))],
TypingTacs []
] *}


ML_quiet {*
val id_loopbody_ttyping_details_future = get_all_typing_details_future @{context} "id_loopbody"
   id_loopbody_typecorrect_script*}


lemma id_loopbody_typecorrect :
  "\<Xi>, fst id_loopbody_type, (id_loopbody_typetree, [Some (fst (snd id_loopbody_type))]) T\<turnstile> id_loopbody : snd (snd id_loopbody_type)"
  apply (tactic {* resolve_future_typecorrect @{context} id_loopbody_ttyping_details_future *})
  done

ML_quiet {*
val id_f_typecorrect_script : hints list = [
KindingTacs [(RTac @{thm typing_helper_1})],
KindingTacs [(RTac @{thm typing_helper_1})],
TypingTacs [],
KindingTacs [(RTac @{thm typing_helper_5})],
TypingTacs [(RTac @{thm typing_lit'}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac []),(SimpTac ([],[]))],
KindingTacs [(RTac @{thm typing_helper_1})],
TypingTacs [(RTac @{thm typing_cast}),(RTac @{thm typing_var}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [@{thm typing_helper_5}]),(SimpTac ([],[])),(SimpTac ([],[]))],
KindingTacs [(RTac @{thm typing_helper_6})],
TypingTacs [(RTac @{thm typing_fun'}),(RTac @{thm id_loopbody_typecorrect[simplified id_loopbody_type_def id_loopbody_typetree_def abbreviated_type_defs, simplified]}),(RTac @{thm typing_helper_7}),(SimpTac ([],[])),(SimpTac ([],[])),(RTac @{thm exI[where x = "{E,S,D}"]}),(RTac @{thm typing_helper_2}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [])],
KindingTacs [(RTac @{thm typing_helper_5})],
TypingTacs [(RTac @{thm typing_lit'}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac []),(SimpTac ([],[]))],
KindingTacs [(RTac @{thm typing_helper_1})],
TypingTacs [(RTac @{thm typing_cast}),(RTac @{thm typing_var}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [@{thm typing_helper_5}]),(SimpTac ([],[])),(SimpTac ([],[]))],
KindingTacs [(RTac @{thm typing_helper_8})],
TypingTacs [],
TypingTacs [(RTac @{thm typing_app}),(SplitsTac (8,[(0,[(RTac @{thm split_comp.right}),(RTac @{thm typing_helper_8})])])),(RTac @{thm typing_afun'}),(SimpTac ([@{thm \<Xi>_def},@{thm seq32_0_type_def[unfolded abbreviated_type_defs]}],[])),(RTac @{thm typing_helper_7}),(SimpTac ([],[])),(SimpTac ([],[])),(RTac @{thm exI[where x = "{E,S,D}"]}),(RTac @{thm typing_helper_9}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac []),(RTac @{thm typing_var}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [@{thm typing_helper_8}]),(SimpTac ([],[]))]
] *}


ML_quiet {*
val id_f_ttyping_details_future = get_all_typing_details_future @{context} "id_f"
   id_f_typecorrect_script*}


lemma id_f_typecorrect :
  "\<Xi>, fst id_f_type, (id_f_typetree, [Some (fst (snd id_f_type))]) T\<turnstile> id_f : snd (snd id_f_type)"
  apply (tactic {* resolve_future_typecorrect @{context} id_f_ttyping_details_future *})
  done

ML_quiet {*
val triangular_loopbody_typecorrect_script : hints list = [
KindingTacs [(RTac @{thm typing_helper_2})],
KindingTacs [(RTac @{thm typing_helper_1})],
KindingTacs [(RTac @{thm typing_helper_3})],
TypingTacs [],
KindingTacs [(RTac @{thm typing_helper_1})],
KindingTacs [(RTac @{thm typing_helper_1})],
KindingTacs [(RTac @{thm typing_helper_4})],
TypingTacs [],
KindingTacs [(RTac @{thm typing_helper_1})],
KindingTacs [(RTac @{thm typing_helper_1})],
TypingTacs [(RTac @{thm typing_app}),(SplitsTac (5,[(0,[(RTac @{thm split_comp.right}),(RTac @{thm typing_helper_1})]),(1,[(RTac @{thm split_comp.left}),(RTac @{thm typing_helper_4})])])),(RTac @{thm typing_fun'}),(RTac @{thm id_f_typecorrect[simplified id_f_type_def id_f_typetree_def abbreviated_type_defs, simplified]}),(RTac @{thm typing_helper_7}),(SimpTac ([],[])),(SimpTac ([],[])),(RTac @{thm exI[where x = "{E,S,D}"]}),(RTac @{thm typing_helper_1}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [@{thm typing_helper_4}]),(RTac @{thm typing_var}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [@{thm typing_helper_1}]),(SimpTac ([],[]))],
TypingTacs []
] *}


ML_quiet {*
val triangular_loopbody_ttyping_details_future = get_all_typing_details_future @{context} "triangular_loopbody"
   triangular_loopbody_typecorrect_script*}


lemma triangular_loopbody_typecorrect :
  "\<Xi>, fst triangular_loopbody_type, (triangular_loopbody_typetree, [Some (fst (snd triangular_loopbody_type))]) T\<turnstile> triangular_loopbody : snd (snd triangular_loopbody_type)"
  apply (tactic {* resolve_future_typecorrect @{context} triangular_loopbody_ttyping_details_future *})
  done

ML_quiet {*
val triangular_typecorrect_script : hints list = [
KindingTacs [(RTac @{thm typing_helper_1})],
KindingTacs [(RTac @{thm typing_helper_1})],
TypingTacs [],
KindingTacs [(RTac @{thm typing_helper_5})],
TypingTacs [(RTac @{thm typing_lit'}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac []),(SimpTac ([],[]))],
KindingTacs [(RTac @{thm typing_helper_1})],
TypingTacs [(RTac @{thm typing_cast}),(RTac @{thm typing_var}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [@{thm typing_helper_5}]),(SimpTac ([],[])),(SimpTac ([],[]))],
KindingTacs [(RTac @{thm typing_helper_6})],
TypingTacs [(RTac @{thm typing_fun'}),(RTac @{thm triangular_loopbody_typecorrect[simplified triangular_loopbody_type_def triangular_loopbody_typetree_def abbreviated_type_defs, simplified]}),(RTac @{thm typing_helper_7}),(SimpTac ([],[])),(SimpTac ([],[])),(RTac @{thm exI[where x = "{E,S,D}"]}),(RTac @{thm typing_helper_2}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [])],
KindingTacs [(RTac @{thm typing_helper_5})],
TypingTacs [(RTac @{thm typing_lit'}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac []),(SimpTac ([],[]))],
KindingTacs [(RTac @{thm typing_helper_1})],
TypingTacs [(RTac @{thm typing_cast}),(RTac @{thm typing_var}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [@{thm typing_helper_5}]),(SimpTac ([],[])),(SimpTac ([],[]))],
KindingTacs [(RTac @{thm typing_helper_8})],
TypingTacs [],
TypingTacs [(RTac @{thm typing_app}),(SplitsTac (8,[(0,[(RTac @{thm split_comp.right}),(RTac @{thm typing_helper_8})])])),(RTac @{thm typing_afun'}),(SimpTac ([@{thm \<Xi>_def},@{thm seq32_0_type_def[unfolded abbreviated_type_defs]}],[])),(RTac @{thm typing_helper_7}),(SimpTac ([],[])),(SimpTac ([],[])),(RTac @{thm exI[where x = "{E,S,D}"]}),(RTac @{thm typing_helper_9}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac []),(RTac @{thm typing_var}),(SimpTac ([@{thm empty_def}],[])),(WeakeningTac [@{thm typing_helper_8}]),(SimpTac ([],[]))]
] *}


ML_quiet {*
val triangular_ttyping_details_future = get_all_typing_details_future @{context} "triangular"
   triangular_typecorrect_script*}


lemma triangular_typecorrect :
  "\<Xi>, fst triangular_type, (triangular_typetree, [Some (fst (snd triangular_type))]) T\<turnstile> triangular : snd (snd triangular_type)"
  apply (tactic {* resolve_future_typecorrect @{context} triangular_ttyping_details_future *})
  done

ML_quiet {*
val (_, id_loopbody_typing_tree, id_loopbody_typing_bucket)
= Future.join id_loopbody_ttyping_details_future
*}


ML_quiet {*
val (_, id_f_typing_tree, id_f_typing_bucket)
= Future.join id_f_ttyping_details_future
*}


ML_quiet {*
val (_, triangular_loopbody_typing_tree, triangular_loopbody_typing_bucket)
= Future.join triangular_loopbody_ttyping_details_future
*}


ML_quiet {*
val (_, triangular_typing_tree, triangular_typing_bucket)
= Future.join triangular_ttyping_details_future
*}


inductive seq32_0_sem where
   "to \<ge> frm \<Longrightarrow>
    seq32_0_sem \<xi> (\<sigma>, URecord [(UPrim (LU32 frm), r1), (UPrim (LU32 to), r2),
                               (UFunction loop_body [], r3), (acc, r4)])
                  (\<sigma>, acc)"
 | "\<lbrakk> to < frm;
      seq32_0_sem \<xi> (\<sigma>, URecord [(UPrim (LU32 frm), r1), (UPrim (LU32 (to - 1)), r2),
                                 (UFunction loop_body [], r4), (acc, r5)])
                    (\<sigma>', acc');
      \<xi>, [UFunction loop_body [], URecord [(acc', r5), (UPrim (LU32 (to - 1)), r5)]]
        \<turnstile> (\<sigma>', App (Var 0) (Var 1)) \<Down>! (\<sigma>'', acc'') \<rbrakk> \<Longrightarrow>
    seq32_0_sem \<xi> (\<sigma>, URecord [(UPrim (LU32 frm), r1), (UPrim (LU32 to), r2),
                               (UFunction loop_body [], r4), (acc, r5)])
                  (\<sigma>'', acc'')"


(* Parse C code *)
new_C_include_dir "../../cogent/lib"
new_C_include_dir "stdlib"
install_C_file "loopfull.c"
autocorres [ts_rules=nondet, no_opt, skip_word_abs] "loopfull.c"
(* *)

(* C type and value relations *)
instantiation unit_t_C :: cogent_C_val begin
  definition type_rel_unit_t_C_def: "type_rel r (_ :: unit_t_C itself) \<equiv> r = RUnit"
  definition val_rel_unit_t_C_def: "val_rel uv (_ :: unit_t_C) \<equiv> uv = UUnit"
  instance ..
end

instantiation bool_t_C :: cogent_C_val
begin
  definition type_rel_bool_t_C_def:
    "type_rel typ (_ :: bool_t_C itself) \<equiv> (typ = RPrim Bool)"
  definition val_rel_bool_t_C_def:
    "val_rel uv (x :: bool_t_C) \<equiv> uv = UPrim (LBool (bool_t_C.boolean_C x \<noteq> 0))"
  instance ..
end

defs cogent_function_type_rel:
  "cogent_function_type_rel typ x \<equiv> typ = RFun"
defs cogent_function_val_rel:
  "cogent_function_val_rel uv x \<equiv>
      (uv = UFunction id_loopbody [] \<and> x = sint FUN_ENUM_id_loopbody) \<or>
      (uv = UFunction triangular_loopbody [] \<and> x = sint FUN_ENUM_triangular_loopbody)"


local_setup{* local_setup_val_rel_type_rel_put_them_in_buckets "loopfull.c" *}

locale loop_proof = loopfull + update_sem_init
begin

local_setup{* local_setup_take_put_member_case_esac_specialised_lemmas "loopfull.c" *}

local_setup {* fold tidy_C_fun_def' COGENT_functions *}

lemmas seq32_0'_def' = seq32_0'.simps
  [simplified return_exn_simp, simplified guard_True_bind]

lemmas dispatch_t2'_def' = dispatch_t2'.simps
  [simplified return_exn_simp, simplified guard_True_bind]



(* Specializations for dispatch_t2 *)
schematic_lemma t2_dispatch_id_loopbody:
  "\<lbrakk> tag = FUN_ENUM_id_loopbody; 0 < m \<rbrakk> \<Longrightarrow>
   dispatch_t2' m tag args = id_loopbody' args"
  by (monad_eq simp: dispatch_t2'_def')

schematic_lemma t2_dispatch_triangular_loopbody:
  "\<lbrakk> tag = FUN_ENUM_triangular_loopbody; 0 < m \<rbrakk> \<Longrightarrow>
   dispatch_t2' m tag args = triangular_loopbody' (recguard_dec m) args"
  by (monad_eq simp: dispatch_t2'_def' FUN_ENUM_id_loopbody_def FUN_ENUM_triangular_loopbody_def)

(* TODO: proof for abstract function *)

definition \<xi>0 :: "(funtyp, abstyp, ptrtyp) uabsfuns" where "\<xi>0 fn \<equiv> undefined"
definition \<xi>1 :: "(funtyp, abstyp, ptrtyp) uabsfuns" where "\<xi>1 fn \<equiv> case fn of ''seq32_0'' \<Rightarrow> seq32_0_sem \<xi>0"
definition \<xi>2 :: "(funtyp, abstyp, ptrtyp) uabsfuns" where "\<xi>2 fn \<equiv> case fn of ''seq32_0'' \<Rightarrow> seq32_0_sem \<xi>1"

lemma seq32_0_corres_0[simplified fst_conv snd_conv seq32_0_type_def id_loopbody_type_def abbreviated_type_defs]:
  "\<lbrakk> 0 < m;
     \<And>v v' \<sigma>' s'. val_rel v v' \<Longrightarrow>
       corres srel
         (App (Fun f []) (Var 0))
         (do ret \<leftarrow> dispatch_t2' (recguard_dec m) (t3_C.f_C a') v';
             gets (\<lambda>_. ret) od)
         \<xi>0 (v # \<gamma>') \<Xi> (Some (fst (snd id_loopbody_type)) # \<Gamma>'') \<sigma>' s';
     val_rel a a';
     case a of URecord xs \<Rightarrow> fst (xs ! 2) = UFunction f []
   \<rbrakk> \<Longrightarrow>
   corres srel
     (App (AFun ''seq32_0'' []) (Var 0))
     (do ret \<leftarrow> seq32_0' m a'; gets (\<lambda>_. ret) od)
     \<xi>1 (a # \<gamma>) \<Xi> (Some (fst (snd seq32_0_type)) # \<Gamma>') \<sigma> s"
  apply (clarsimp simp: corres_def' seq32_0'_def')

  apply (rule validNF_bind[where B = "\<lambda>_ s0. s0 = s", rotated])
   apply (monad_eq simp: validNF_def valid_def no_fail_def)
  apply (subst whileLoop_add_inv
           [where M = "\<lambda>((_, i), _). t3_C.to_C a' - i"
              and I = "\<lambda>(fargs, i) s. \<exists>\<sigma>' args.
          (\<sigma>', s) \<in> srel \<and>
          val_rel args (t3_C.to_C_update (\<lambda>_. i) a') \<and>
          seq32_0_sem \<xi>1 (\<sigma>, args) (\<sigma>', UPrim (LU32 (t1_C.acc_C fargs)))"])
  apply wp
  sorry

lemma seq32_0_corres_1[simplified fst_conv snd_conv seq32_0_type_def id_loopbody_type_def abbreviated_type_defs]:
  "\<lbrakk> 0 < m;
     \<And>v v' \<sigma>' s'. val_rel v v' \<Longrightarrow>
       corres srel
         (App (Fun f []) (Var 0))
         (do ret \<leftarrow> dispatch_t2' (recguard_dec m) (t3_C.f_C a') v';
             gets (\<lambda>_. ret) od)
         \<xi>1 (v # \<gamma>') \<Xi> (Some (fst (snd id_loopbody_type)) # \<Gamma>'') \<sigma>' s';
     val_rel a a';
     case a of URecord xs \<Rightarrow> fst (xs ! 2) = UFunction f []
   \<rbrakk> \<Longrightarrow>
   corres srel
     (App (AFun ''seq32_0'' []) (Var 0))
     (do ret \<leftarrow> seq32_0' m a'; gets (\<lambda>_. ret) od)
     \<xi>2 (a # \<gamma>) \<Xi> (Some (fst (snd seq32_0_type)) # \<Gamma>') \<sigma> s"
  sorry


(* Proofs *)
lemmas corres_nested_let = TrueI (* dummy for corres_tac *)

lemma id_loopbody_corres[unfolded id_loopbody_type_def abbreviated_type_defs fst_conv snd_conv]:
  "val_rel a a' \<Longrightarrow> corres srel id_loopbody (id_loopbody' a') \<xi>0 [a] \<Xi> [Some (fst (snd id_loopbody_type))] \<sigma> s"
  apply (tactic {* corres_tac @{context}
    (peel_two id_loopbody_typing_tree)
    @{thms id_loopbody_def id_loopbody_type_def id_loopbody'_def' abbreviated_type_defs}
    [] [] @{thm TrueI} []
    @{thms val_rel_word val_rel_fun_tag cogent_function_val_rel}
    @{thms type_rel_word}
    [] @{thm LETBANG_TRUE_def} @{thms list_to_map_more[where f=Var] list_to_map_singleton[where f=Var]}
    true *})
  done

lemma seq32_0_id_loopbody_corres[unfolded seq32_0_type_def abbreviated_type_defs fst_conv snd_conv]:
  "\<lbrakk> m \<ge> 3;
     val_rel a a';
     f_C a' = FUN_ENUM_id_loopbody
  \<rbrakk> \<Longrightarrow>
  corres srel
    (App (AFun ''seq32_0'' []) (Var 0))
    (do ret \<leftarrow> seq32_0' (recguard_dec m) a'; gets (\<lambda>_. ret) od)
    \<xi>1 (a # \<gamma>) \<Xi>
    (Some (fst (snd seq32_0_type)) # \<Gamma>') \<sigma> s"
  apply (unfold seq32_0_type_def abbreviated_type_defs fst_conv snd_conv)
  apply (rule seq32_0_corres_0[where f=id_loopbody])
     apply (simp add: recguard_dec_def)
    apply (simp add: dispatch_t2'_def')
    apply (subst condition_true_pure)
     apply (simp add: recguard_dec_def)
    apply (subst unknown_bind_ignore)
    apply (rule corres_u_sem_eq)
     apply (rule u_sem_app)
       apply (rule u_sem_fun)
      apply (rule u_sem_var)
     apply simp
    apply (rule id_loopbody_corres)
    apply simp
   apply simp
  apply (clarsimp simp: val_rel_t3_C_def val_rel_fun_tag cogent_function_val_rel
                        FUN_ENUM_id_loopbody_def FUN_ENUM_triangular_loopbody_def)
  done

lemma id_f_corres[unfolded id_f_type_def abbreviated_type_defs fst_conv snd_conv]:
  "\<lbrakk> m \<ge> 3; val_rel a a' \<rbrakk> \<Longrightarrow>
   corres srel id_f (id_f' m a') \<xi>1 [a] \<Xi> [Some (fst (snd id_f_type))] \<sigma> s"
  apply (tactic {* corres_tac @{context}
    (peel_two id_f_typing_tree)
    @{thms id_f_def id_f_type_def id_f'_def' abbreviated_type_defs}
    @{thms seq32_0_id_loopbody_corres} [] @{thm TrueI} []
    @{thms val_rel_word val_rel_fun_tag cogent_function_val_rel}
    @{thms type_rel_word}
    [] @{thm LETBANG_TRUE_def} @{thms list_to_map_more[where f=Var] list_to_map_singleton[where f=Var]}
    true *})
  done

lemma triangular_loopbody_corres[unfolded triangular_loopbody_type_def abbreviated_type_defs fst_conv snd_conv]:
  "\<lbrakk> m \<ge> 4; val_rel a a' \<rbrakk> \<Longrightarrow>
   corres srel triangular_loopbody (triangular_loopbody' m a')
          \<xi>1 [a] \<Xi> [Some (fst (snd triangular_loopbody_type))] \<sigma> s"
  apply (tactic {* corres_tac @{context}
    (peel_two triangular_loopbody_typing_tree)
    @{thms triangular_loopbody_def triangular_loopbody_type_def triangular_loopbody'_def' abbreviated_type_defs}
    [] @{thms id_f_corres} @{thm TrueI} []
    @{thms val_rel_word val_rel_fun_tag cogent_function_val_rel}
    @{thms type_rel_word}
    [] @{thm LETBANG_TRUE_def} @{thms list_to_map_more[where f=Var] list_to_map_singleton[where f=Var]}
    true *})
  done

lemma seq32_0_triangular_loopbody_corres[unfolded seq32_0_type_def abbreviated_type_defs fst_conv snd_conv]:
  "\<lbrakk> m \<ge> 7; val_rel a a'; f_C a' = FUN_ENUM_triangular_loopbody \<rbrakk> \<Longrightarrow>
  corres srel
    (App (AFun ''seq32_0'' []) (Var 0))
    (do ret \<leftarrow> seq32_0' (recguard_dec m) a'; gets (\<lambda>_. ret) od)
    \<xi>2 (a # \<gamma>) \<Xi>
    (Some (fst (snd seq32_0_type)) # \<Gamma>') \<sigma> s"
  apply (unfold seq32_0_type_def abbreviated_type_defs fst_conv snd_conv)
  apply (rule seq32_0_corres_1[where f=triangular_loopbody])
     apply (simp add: recguard_dec_def)
    apply (simp add: dispatch_t2'_def')
    apply (subst condition_false_pure)
     apply (simp add: FUN_ENUM_id_loopbody_def FUN_ENUM_triangular_loopbody_def)
    apply (subst unknown_bind_ignore)
    apply (rule corres_u_sem_eq)
     apply (rule u_sem_app)
       apply (rule u_sem_fun)
      apply (rule u_sem_var)
     apply simp
    apply (clarsimp simp: recguard_dec_def)
    apply (rule triangular_loopbody_corres)
     apply simp
    apply simp
   apply simp
  apply (clarsimp simp: val_rel_t3_C_def val_rel_fun_tag cogent_function_val_rel
                        FUN_ENUM_id_loopbody_def FUN_ENUM_triangular_loopbody_def)
  done

lemma triangular_corres[unfolded triangular_type_def abbreviated_type_defs fst_conv snd_conv]:
  "val_rel a a' \<Longrightarrow> corres srel triangular (triangular' a') \<xi>2 [a] \<Xi> [Some (fst (snd triangular_type))] \<sigma> s"
  apply (tactic {* corres_tac @{context}
    (peel_two triangular_typing_tree)
    @{thms triangular_def triangular_type_def triangular'_def' abbreviated_type_defs}
    @{thms seq32_0_triangular_loopbody_corres} [] @{thm TrueI} []
    @{thms val_rel_word val_rel_fun_tag cogent_function_val_rel}
    @{thms type_rel_word}
    [] @{thm LETBANG_TRUE_def} @{thms list_to_map_more[where f=Var] list_to_map_singleton[where f=Var]}
    true *})
  done

end


text {* Automatic proof of COGENT code, pushing abstract proof obligations into assumptions. *}

context loop_proof begin

lemmas [ValRelSimp] = val_rel_bool_t_C_def val_rel_unit_t_C_def val_rel_word val_rel_fun_tag cogent_function_val_rel
lemmas [TypeRelSimp] = type_rel_bool_t_C_def type_rel_unit_t_C_def type_rel_word type_rel_fun_tag

definition "state_rel \<equiv> UNIV"
ML {*
  fun corres_tac_local verbose ctxt
         (typing_tree : thm Tree)
         (fun_defs : thm list)
         (absfun_corres : thm list)
         (fun_corres : thm list) =
      corres_tac ctxt
         (typing_tree)
         (fun_defs)
         (absfun_corres)
         (fun_corres) 
         @{thm TrueI}             (* corres_if *)
         @{thms corres_esacs}         (* corres_esacs *)
         @{thms untyped_func_enum_defs}
         []
         @{thms TrueI} (* tag_enum_defs *)
         @{thm LETBANG_TRUE_def}
         @{thms list_to_map_more[where f=Var] 
                list_to_map_singleton[where f=Var]}
         verbose;
*}

ML {*
fun typing_tree_of "id_loopbody" = id_loopbody_typing_tree
  | typing_tree_of "id_f" = id_f_typing_tree
  | typing_tree_of "triangular_loopbody" = triangular_loopbody_typing_tree
  | typing_tree_of "triangular" = triangular_typing_tree
  | typing_tree_of f = error ("No typing tree for " ^ quote f)
*}

ML {*
(* Categorise *)
val [(COGENT_functions_FO, COGENT_functions_HO), (COGENT_abstract_functions_FO, COGENT_abstract_functions_HO)] =
  map (partition (get_COGENT_funtype @{context} #> Thm.prop_of #> Utils.rhs_of_eq #> funtype_is_first_order))
      [COGENT_functions, COGENT_abstract_functions];
val _ = if null COGENT_functions_HO then () else
          error ("Don't know how to handle higher-order COGENT functions: " ^ commas_quote COGENT_functions_HO);
*}

ML {*
(* translate COGENT Invalue pointers to C record lookup terms *)
fun name_field ctxt (nm, funcs) = let
   val nm' = case nm of Left f => f | Right f => f
   val T = case Syntax.read_term ctxt (nm' ^ "'") of
       Const (_, T) => T | t => raise TERM ("name_field: ", [t])
   val sourceT = domain_type T
   (* Ignore measure (first parameter) for recursive C functions *)
   val sourceT = if sourceT = @{typ nat} then domain_type (range_type T) else sourceT
   fun typ_string T = dest_Type T |> fst
   val source_var = Free ("x", sourceT)
   fun access sourceT t [] = t
     | access sourceT t (getter::getters) = let
         val getterm = Syntax.read_term ctxt (typ_string sourceT ^ "." ^ getter)
         val destT = range_type (type_of getterm)
         in access destT (getterm $ t) getters end
  in (nm, map (apfst (access sourceT source_var #> lambda source_var)) funcs) end
*}

(* Higher-order function call annotations. *)
ML {*
val HO_call_hints =
     COGENT_functions
     |> Par_List.map (fn f => case COGENTHigherOrder.make_HO_call_hints @{context} "loopfull.c" f of
            [] => [] | hints => [(f, map (name_field @{context}) hints)])
     |> List.concat
     |> Symtab.make
     : ((string, string) Either * (term * (string, string) Either) list) list Symtab.table
*}

ML {*
(* Sanity check HO_call_hints. *)
val _ = Symtab.dest HO_call_hints |> map (fn (f, calls) => (
  (if member (op =) COGENT_functions f then () else error ("HO_call_hints: no such function " ^ quote f));
  map (fn af => case af of Right _ => () | Left af =>
                  if member (op =) COGENT_abstract_functions af then () else
                    error ("HO_call_hints: no such absfun " ^ quote af))
      (map fst calls);
  map (fn af => case af of Right _ => () | Left af =>
                  if member (op =) (Proof_Context.get_thm @{context} (f ^ "_def")
                                    |> Thm.prop_of |> get_simple_function_calls) af then ()
                  else error ("HO_call_hints: absfun " ^ quote af ^ " not in " ^ quote f)) (map fst calls)
  (* TODO: check funargs and completeness *)
  ))
*}

ML {*
(* Abstract function names in the AST don't have theory prefixes *)
fun maybe_unprefix pre str = if String.isPrefix pre str then unprefix pre str else str
fun mapBoth f = mapEither f f
(* Entry point for verification *)
val COGENT_main_tree =
  make_call_tree (COGENT_functions, COGENT_abstract_functions)
    (Symtab.map (K (map (apsnd (map (apsnd (mapBoth (maybe_unprefix "Loop."))))))) HO_call_hints) @{context}
  |> Symtab.map (K (annotate_depth #> annotate_measure))

val entry_funcs = Symtab.dest COGENT_main_tree
      |> filter (fn (n, _) => member op= COGENT_functions n) |> Symtab.make
*}

(* Define \<xi>_n. *)
ML {*
(* FIXME: actually merge trees for uabsfuns *)
val (deepest_tree::_) =
  Symtab.dest COGENT_main_tree |> map snd |> filter (fn tr =>
    fst (COGENTCallTree_data tr) =
    (Symtab.dest COGENT_main_tree |> map snd |> map COGENTCallTree_data |> map fst |> maximum))
  |> map (map_annotations fst)
*}
local_setup {* define_uabsfuns' deepest_tree *}

(* Define corres theorems for all function calls under entry_funcs *)
ML {* val prop_tab = corres_tree_obligations entry_funcs @{context} *}

(* Run proofs for generated functions *)
ML {*
val thm_tab = all_corres_goals (corres_tac_local false) typing_tree_of 42 @{context} prop_tab
*}

(* Resolve function calls recursively *)
ML {*
val finalised_thms =
    Symtab.dest thm_tab
    |> Par_List.map (fn (n, maybe_thm) =>
         (n, Option.map (simp_xi @{context}) maybe_thm))
    |> Symtab.make
    |> finalise prop_tab @{context}
*}

(* Final theorem for entry point *)
ML {* Symtab.dest prop_tab |> filter (fn (_, p) => member (op=) (Symtab.keys entry_funcs) (#1 p))
      |> map (fn (thm, _) => @{trace} (thm, Symtab.lookup finalised_thms thm |> the |> the)) *}

end

end