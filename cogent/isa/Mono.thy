(*
 * Copyright 2016, NICTA
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(NICTA_GPL)
 *)

theory Mono
imports ValueSemantics 
begin

context value_sem
begin


(* Rename abstract functions (AFun) in an expression.
 * This lets us switch between the polymorphic and monomorphic environments
 * where monomorphised functions have different names. *)
fun
  rename_expr :: "('b \<Rightarrow> 'c) \<Rightarrow> 'b expr \<Rightarrow> 'c expr"
where
  "rename_expr rename (AFun f ts)       = AFun (rename f) ts"
| "rename_expr rename (Fun f ts)        = Fun (rename_expr rename f) ts"
| "rename_expr rename (Var i)           = Var i"
| "rename_expr rename (Prim p es)       = Prim p (map (rename_expr rename) es)"
| "rename_expr rename (App a b)         = App (rename_expr rename a) (rename_expr rename b)"
| "rename_expr rename (Con as t e)      = Con as t (rename_expr rename e)" 
| "rename_expr rename (Promote as e)    = Promote as (rename_expr rename e)"
| "rename_expr rename (Struct ts vs)    = Struct ts (map (rename_expr rename) vs)"
| "rename_expr rename (Member v f)      = Member (rename_expr rename v) f"
| "rename_expr rename (Unit)            = Unit"
| "rename_expr rename (Cast t e)        = Cast t (rename_expr rename e)"
| "rename_expr rename (Lit v)           = Lit v"
| "rename_expr rename (Tuple a b)       = Tuple (rename_expr rename a) (rename_expr rename b)"
| "rename_expr rename (Put e f e')      = Put (rename_expr rename e) f (rename_expr rename e')"
| "rename_expr rename (Let e e')        = Let (rename_expr rename e) (rename_expr rename e')"
| "rename_expr rename (LetBang vs e e') = LetBang vs (rename_expr rename e) (rename_expr rename e')"
| "rename_expr rename (Case e t a b)    = Case (rename_expr rename e) t (rename_expr rename a) (rename_expr rename b)"
| "rename_expr rename (Esac e)          = Esac (rename_expr rename e)"
| "rename_expr rename (If c t e)        = If (rename_expr rename c) (rename_expr rename t) (rename_expr rename e)"
| "rename_expr rename (Take e f e')     = Take (rename_expr rename e) f (rename_expr rename e')"
| "rename_expr rename (Split v va)      = Split (rename_expr rename v) (rename_expr rename va)"
 
fun
  rename_val :: "('b \<Rightarrow> 'c) \<Rightarrow> ('b, 'a) vval \<Rightarrow> ('c, 'a) vval"
where
  "rename_val rename (VPrim lit)       = VPrim lit"
| "rename_val rename (VProduct t u)    = VProduct (rename_val rename t) (rename_val rename u)"
| "rename_val rename (VSum name v)     = VSum name (rename_val rename v)"
| "rename_val rename (VRecord vs)      = VRecord (map (rename_val rename) vs)"
| "rename_val rename (VAbstract t)     = VAbstract t"
| "rename_val rename (VAFunction f ts) = VAFunction (rename f) ts"
| "rename_val rename (VFunction f ts)  = VFunction (rename_expr rename f) ts"
| "rename_val rename VUnit             = VUnit"


(* Proof of semantic preservation across rename_expr and monoexpr. *)
definition
  rename_mono_prog ::
  "(('f \<times> type list) \<Rightarrow> 'f) \<Rightarrow> ('f \<Rightarrow> poly_type) \<Rightarrow> ('f, 'a) vabsfuns \<Rightarrow> ('f, 'a) vabsfuns \<Rightarrow> bool"
where
  "rename_mono_prog rename \<Xi> \<xi>\<^sub>r\<^sub>m \<xi>\<^sub>p \<equiv>
     \<xi>\<^sub>r\<^sub>m matches \<Xi> \<longrightarrow>
     proc_ctx_wellformed \<Xi> \<longrightarrow>
     (\<forall>f ts v v'. \<xi>\<^sub>r\<^sub>m (rename (f, ts)) (rename_val rename (monoval v)) v' \<longrightarrow>
        (\<exists> v''. v' = rename_val rename (monoval v'') \<and>  \<xi>\<^sub>p f v v''))"

fun 
  rename_monoval_prog :: "(('f \<times> type list) \<Rightarrow> 'f) \<Rightarrow> ('f, 'a) vabsfuns \<Rightarrow> ('f \<times> type list) \<Rightarrow>
                  ('f, 'a) vval \<Rightarrow> ('f, 'a) vval \<Rightarrow> bool"
where
  "rename_monoval_prog rename \<xi> n v1 v2 =
     \<xi> (rename n) (rename_val rename (monoval v1)) (rename_val rename (monoval v2))"

lemma rename_monoval_prim_prim:
  "rename_val rename (monoval v) = VPrim l \<Longrightarrow> v = VPrim l"
  by (induct v, simp_all)

lemma map_rename_monoval_prim_prim:
  "map (rename_val rename \<circ> monoval) vs = map VPrim ls \<Longrightarrow> vs = map VPrim ls"
  by (induct vs arbitrary: ls) (auto simp: rename_monoval_prim_prim)

lemma rename_monoexpr_correct:
  assumes "proc_ctx_wellformed \<Xi>"
  and     "\<xi>\<^sub>r\<^sub>m matches \<Xi>"
  and     "rename_mono_prog rename \<Xi> \<xi>\<^sub>r\<^sub>m \<xi>\<^sub>p"
  and     "\<Xi> \<turnstile> map (rename_val rename \<circ> monoval) \<gamma> matches \<Gamma>"
  shows   "\<xi>\<^sub>r\<^sub>m, map (rename_val rename \<circ> monoval) \<gamma> \<turnstile> rename_expr rename (monoexpr e) \<Down> v' \<Longrightarrow> 
             \<Xi>, [], \<Gamma> \<turnstile> rename_expr rename (monoexpr e) : \<tau>  \<Longrightarrow> 
             \<exists>v. \<xi>\<^sub>p, \<gamma> \<turnstile> e \<Down>  v \<and> v' = rename_val rename (monoval v)"
  and     "\<xi>\<^sub>r\<^sub>m, map (rename_val rename \<circ> monoval) \<gamma> \<turnstile>* map (rename_expr rename \<circ> monoexpr) es \<Down> vs' \<Longrightarrow> 
             \<Xi>, [], \<Gamma> \<turnstile>* map (rename_expr rename \<circ> monoexpr) es : \<tau>s \<Longrightarrow> 
             \<exists>vs. (\<xi>\<^sub>p , \<gamma> \<turnstile>* es \<Down> vs) \<and> vs' = (map (rename_val rename \<circ> monoval) vs)"
  using assms 
  proof (induct \<xi>\<^sub>r\<^sub>m "map (rename_val rename \<circ> monoval) \<gamma>" "rename_expr rename (monoexpr e)" v'
            and \<xi>\<^sub>r\<^sub>m "map (rename_val rename \<circ> monoval) \<gamma>" "map (rename_expr rename \<circ> monoexpr) es" vs'
         arbitrary: \<tau> \<Gamma> \<gamma> e 
           and \<tau>s \<Gamma> \<gamma> es
         rule: v_sem_v_sem_all.inducts)
  case (v_sem_var \<xi> i \<gamma> e \<tau> \<Gamma>)
  then show ?case 
  apply (cases e, simp_all)
  apply (rule_tac x="\<gamma>!i" in exI)
  by (fastforce intro: v_sem_v_sem_all.v_sem_var dest: matches_length)
  next 
  case (v_sem_lit \<xi> l \<gamma> e  \<tau> \<Gamma>) then show ?case 
  by (cases e) (auto intro: v_sem_v_sem_all.v_sem_lit)
  next 
  case (v_sem_fun \<xi> f ts \<gamma> e \<tau> \<Gamma>) then show ?case 
  by (cases e) (auto intro: v_sem_v_sem_all.v_sem_fun)
  next 
  case (v_sem_afun \<xi> f ts \<gamma> e \<tau> \<Gamma>) then show ?case 
  by (cases e) (auto intro: v_sem_v_sem_all.v_sem_afun)
  next 
  case (v_sem_cast \<xi> re l \<tau> l'  \<gamma> e \<tau>' \<Gamma>) 
  note IH1=this(2) and rest= this(1,3-) then show ?case 
  apply (cases e, simp_all)
  apply (rule exI)
  apply (rule conjI)
   apply (erule typing_castE)
   apply (rule v_sem_v_sem_all.v_sem_cast)
    apply (rule IH1[THEN exE], simp_all)
  apply (rename_tac v)
  apply clarsimp
  by (case_tac v, simp_all)
  next 
  case (v_sem_con \<xi> re rv as t \<gamma> e \<tau> \<Gamma>) then show ?case
  apply (cases e, simp_all)
  by (fastforce intro!: v_sem_v_sem_all.v_sem_con)
  next 
  case (v_sem_promote \<xi> x x' t \<gamma> e \<tau> \<Gamma>) then show ?case 
  by (cases e, simp_all) (fastforce intro!: v_sem_v_sem_all.v_sem_promote)
  next 
  case (v_sem_unit \<xi> \<gamma> e \<tau> \<Gamma>) then show ?case
  apply (cases e, simp_all) 
  by (fastforce intro!:  v_sem_v_sem_all.v_sem_unit) 
  next 
  case (v_sem_tuple \<xi> re1 rv1 re2 rv2 \<gamma> e \<tau> \<Gamma>) then show ?case
  apply (cases e, simp_all)
  by (fastforce intro: matches_split' v_sem_v_sem_all.v_sem_tuple)
  next 
  case (v_sem_esac \<xi> t ts v \<gamma> e \<tau> \<Gamma>) 
  note IH1=this(2) and rest= this(1,3-) from rest show ?case 
  apply (cases e, simp_all)
  apply (erule typing_esacE)
  apply (cut_tac IH1, simp_all)
  apply (erule exE)
  apply (rename_tac vval)
  apply (case_tac vval, simp_all)
  by (fastforce intro!: v_sem_v_sem_all.v_sem_esac)
  next 
  case (v_sem_struct \<xi> xs vs ts \<gamma> e \<tau> \<Gamma>) then show ?case
  by (cases e, simp_all) (fastforce intro: v_sem_v_sem_all.v_sem_struct)
  next 
  case (v_sem_if \<xi> rb b e1 e2 v \<gamma> e \<tau> \<Gamma>)
  note IH1=this(2) and IH2=this(4) and rest=this(1,3, 5-) from rest show ?case 
  apply (cases e, simp_all)
  apply (rename_tac exp1 exp2 exp3)
  apply (erule typing_ifE)
  apply (cut_tac IH1[OF _ _ _ _ _ _ matches_split'(1)], simp_all)
  apply (clarsimp)
  apply (rename_tac vval)
  apply (case_tac vval, simp_all)
  apply (subgoal_tac "\<exists>va. (\<xi>\<^sub>p , \<gamma> \<turnstile> if b then exp2 else exp3 \<Down> va) \<and> v = rename_val rename (monoval va)")
   apply (fastforce intro: v_sem_v_sem_all.v_sem_if)
  apply (rule IH2[OF _ _ _ _ _ _ matches_split'(2)], simp_all)
  apply (fastforce split: split_if_asm)
  done
  next 
  case v_sem_all_empty then show ?case 
  by (simp add: v_sem_v_sem_all.v_sem_all_empty)
  next
  case (v_sem_all_cons \<xi> e v es' vs' \<gamma> es \<tau>s \<Gamma>) then show ?case 
  by (cases es, simp) (fastforce dest: matches_split' intro!: v_sem_v_sem_all.intros)
  next 
  case (v_sem_prim \<xi> es vs p \<gamma> e \<tau> \<Gamma>)
  note IH = this(2) 
  and rest = this(1,3-)
  from rest show ?case
  apply (cases e, simp_all)
  apply (clarsimp elim!: typing_primE)

  apply (cut_tac IH, simp_all)
  apply clarsimp
  apply (frule(4) preservation(2) [where \<tau>s = "[]" and K = "[]", simplified])
  apply (frule v_t_map_TPrimD)
  apply clarsimp
  apply (frule eval_prim_preservation)
   apply (simp)
  apply (erule vval_typing.cases, simp_all)
  apply (rule exI)
  apply (rule conjI)
  apply (rule v_sem_prim', simp_all)
  by (force dest: map_rename_monoval_prim_prim)
  next 
  case (v_sem_put \<xi> r fs re rv f \<gamma> e \<tau> \<Gamma>) 
  note IH1=this(2) 
  and IH2=this(4) 
  and rest= this(1,3, 5-) 
  from rest show ?case 
  apply (cases e, simp_all)
  apply (rename_tac rec f' expr)
  apply (erule typing_putE)
  apply (cut_tac IH1[OF _ _ _ _ _ _ matches_split'(1)], simp_all)
  apply (clarsimp)
  apply (rename_tac rv')
  apply (case_tac rv', simp_all)
  apply (cut_tac IH2[OF _ _ _ _ _ _ matches_split'(2)], simp_all)
  by (fastforce simp: map_update intro: v_sem_v_sem_all.v_sem_put)
  next case (v_sem_let \<xi> e1 rv1 e2 rv2 \<gamma> e \<tau> \<Gamma>)
  note IH1 = this(2) 
  and  IH2 = this(4) 
  and rest = this(1,3,5-) 
  from rest show ?case
  apply (case_tac e, simp_all)
  apply (rename_tac exp1 exp2)
  apply (clarsimp elim!: typing_letE)
  apply (frule(1) matches_split'(1))
  apply (frule(1) matches_split'(2))
  apply (cut_tac IH1[OF _ _ _ _ _ _ matches_split'(1)], simp_all)
  apply clarsimp
  apply (rename_tac v1)
  apply (frule(4) preservation [where \<tau>s = "[]" and K = "[]", simplified])
  apply (drule(2) matches_cons'[OF matches_split'(2)])
  apply (subgoal_tac "\<exists>v. \<xi>\<^sub>p , v1 # \<gamma> \<turnstile> exp2 \<Down> v \<and> rv2 = rename_val rename (monoval v)")
   apply (force intro!: v_sem_v_sem_all.v_sem_let)
  apply (force intro!: IH2)
  done
  next 
  case (v_sem_letbang \<xi> e1 rv1 e2 rv2 vs \<gamma> e \<tau> \<Gamma>)
  note IH1 = this(2) 
  and IH2 = this(4) 
  and rest = this(1,3,5-) 
  from rest show ?case
  apply (cases e, simp_all)
  apply (rename_tac vs exp1 exp2)
  apply (clarsimp elim!: typing_letbE)
  apply (frule(1) matches_split_bang'(1))
  apply (frule(1) matches_split_bang'(2))
  apply (cut_tac IH1[OF _ _ _ _ _ _ matches_split_bang'(1)], simp_all)
  apply clarsimp
  apply (rename_tac v1)
  apply (frule(4) preservation [where \<tau>s = "[]" and K = "[]", simplified])
  apply (drule(2) matches_cons'[OF matches_split_bang'(2)])
  (* cut_tac, but we want to select \<gamma> *)
  apply (subgoal_tac "\<exists>v. \<xi>\<^sub>p , v1 # \<gamma> \<turnstile> exp2 \<Down> v \<and> rv2 = rename_val rename (monoval v)")
   apply (force intro!: v_sem_v_sem_all.v_sem_letbang)
  apply (force intro!: IH2)
  done
  next
  case (v_sem_case_m \<xi> re f rv mre mrv nre \<gamma> e \<tau> \<Gamma>)
  note IH1=this(2) 
  and IH2 = this(4) 
  and rest = this(1,3,5-) 
  from rest show ?case
  apply (cases e, simp_all)
  apply (rename_tac exp1 tag exp2 exp3)
  apply (clarsimp elim!: typing_caseE)
  apply (rename_tac  \<Gamma>1 \<Gamma>2 ts tf)
  apply (frule(1) matches_split'(1))
  apply (frule(1) matches_split'(2))
  apply (cut_tac IH1[OF _ _ _ _ _ _ matches_split'(1)], simp_all)
  apply clarsimp
  apply (rename_tac v1)
  apply (case_tac v1, simp_all)
  apply (rename_tac t' v1')
  apply (frule(4) preservation [where \<tau>s = "[]" and K = "[]", simplified, rotated -3])
  apply (erule v_t_sumE')
  apply (drule(2) matches_cons'[OF matches_split'(2)])
  apply (subgoal_tac "\<exists>v. \<xi>\<^sub>p , v1' # \<gamma> \<turnstile> exp2 \<Down> v \<and> mrv = rename_val rename (monoval v)")
   apply (fastforce intro!: v_sem_v_sem_all.v_sem_case_m)
  apply (fastforce intro!: IH2 dest: distinct_fst)
  done
  next 
  case (v_sem_case_nm \<xi> re f rv f' rne rnv rme \<gamma> e \<tau> \<Gamma>)
  note IH1=this(2) 
  and IH2 = this(5) 
  and rest = this(1,3,4,6-) 
  from rest show ?case
  apply (cases e, simp_all)
  apply (rename_tac exp1 tag exp2 exp3)
  apply (clarsimp elim!: typing_caseE)
  apply (rename_tac  \<Gamma>1 \<Gamma>2 ts tf)
  apply (frule(1) matches_split'(1))
  apply (frule(1) matches_split'(2))
  apply (cut_tac IH1[OF _ _ _ _ _ _ matches_split'(1)], simp_all)
  apply clarsimp
  apply (rename_tac v1)
  apply (case_tac v1, simp_all)
  apply (frule(4) preservation [where \<tau>s = "[]" and K = "[]", simplified, rotated -3])
  apply (drule(1) sum_downcast[OF _ not_sym])
  apply (drule(2) matches_cons'[OF matches_split'(2)])
  apply (subgoal_tac "\<exists>v. \<xi>\<^sub>p , v1 # \<gamma> \<turnstile> exp3 \<Down> v \<and> rnv = rename_val rename (monoval v)") 
   apply (fastforce intro!: v_sem_v_sem_all.v_sem_case_nm)
  apply (force intro!: IH2)
  done
  next
  case (v_sem_member \<xi> re fs f \<gamma> e \<tau> \<Gamma>)
  note IH=this(2) 
  and rest = this(1,3-) 
  from rest show ?case
  apply (case_tac e, simp_all)
  apply (clarsimp elim!: typing_memberE)
  apply (cut_tac IH, simp_all)
  apply clarsimp
  apply (rename_tac rv)
  apply (case_tac rv, simp_all)
  apply (frule(4) preservation [where \<tau>s = "[]" and K = "[]", simplified]) 
  apply (erule v_t_recordE)
  apply (frule vval_typing_record_length) 
  by (fastforce intro: v_sem_v_sem_all.v_sem_member)
  next case (v_sem_split \<xi> ab a b es rv \<gamma> e \<tau> \<Gamma>)
  note IH1 = this(2)
  and  IH2 = this(4)
  and rest = this(1,3,5-)
  from rest show ?case
  apply (case_tac e, simp_all)
  apply (rename_tac exp1 exp2)
  apply (clarsimp elim!: typing_splitE)
  apply (cut_tac IH1[OF _ _ _ _ _ _ matches_split'(1)], simp_all)
  apply clarsimp
  apply (rename_tac v)
  apply (case_tac v, simp_all)
  apply (frule(5) preservation [where \<tau>s = "[]" and K = "[]", OF _ _ matches_split'(1), simplified])
  apply (rename_tac va vb)
  apply (erule v_t_productE)
  apply (drule(1) matches_split'(2)[rotated])
  apply (drule_tac x="rename_val rename (monoval vb)" in matches_cons', simp)
  apply (drule_tac x="rename_val rename (monoval va)" in matches_cons', simp)
  apply (subgoal_tac "\<exists>v. \<xi>\<^sub>p , va # vb # \<gamma> \<turnstile> exp2 \<Down> v \<and> rv = rename_val rename (monoval v)")
   apply (fastforce intro: v_sem_v_sem_all.v_sem_split)
  apply (force intro!: IH2)
  done
  next 
  case (v_sem_take \<xi> re fs f es rv \<gamma> e \<tau> \<Gamma>)
  note IH1 = this(2)
  and  IH2 = this(4)
  and rest = this(1,3,5-)
  from rest show ?case
  apply (case_tac e, simp_all)
  apply (rename_tac exp1 field exp2)
  apply (clarsimp elim!: typing_takeE)
  apply (rename_tac \<Gamma>1 \<Gamma>2 ts s t k taken)
  apply (cut_tac IH1[OF _ _ _ _ _ _ matches_split'(1)], simp_all)
  apply clarsimp
  apply (rename_tac v)
  apply (case_tac v, simp_all)
  apply (rename_tac fs')
  apply (frule(5) preservation [where \<tau>s = "[]" and K = "[]", OF _ _ matches_split'(1), simplified])
  apply (drule(1) matches_split'(2)[rotated])
  apply (drule_tac x="VRecord (map (rename_val rename \<circ> monoval) fs')" and \<tau>="TRecord (ts[f := (t, taken)]) s" and \<Gamma>=\<Gamma>2 
         in matches_cons')
   apply (fastforce dest: vval_typing_record_take intro:v_t_record)
  apply (erule v_t_recordE)
  apply (frule vval_typing_record_length)
  apply (drule_tac x="(map (rename_val rename \<circ> monoval) fs')!f" in matches_cons')
   apply (fastforce dest: vval_typing_record_nth)
  apply (subgoal_tac "\<exists>v. \<xi>\<^sub>p , fs' ! f # VRecord fs' # \<gamma> \<turnstile> exp2 \<Down> v \<and> rv = rename_val rename (monoval v)")
   apply (fastforce intro: v_sem_v_sem_all.v_sem_take)
  apply (force intro!: IH2)
  done
  next
  case (v_sem_app \<xi> re f ts e' rv rsv \<gamma> e \<tau> \<Gamma>)
  note IH1 = this(2)
  and  IH2 = this(4)
  and  IH3 = this(6)
  and  rest = this(1,3,5,7-)
  from rest show ?case
  apply (cases e, simp_all)
  apply (erule typing_appE)
  apply (rename_tac \<Gamma>1 \<Gamma>2 t)
  apply (cut_tac IH1[OF _ _ _ _ _ _ matches_split'(1)], simp_all)
  apply clarsimp
  apply (rename_tac fv)
  apply (case_tac fv, simp_all)
  apply clarsimp
  apply (rename_tac expr ts')
  apply (cut_tac IH2[OF _ _ _ _ _ _ matches_split'(2)], simp_all)
  apply clarsimp
  apply (rename_tac v)
  apply (frule(5) preservation(1) [where \<tau>s = "[]" and K = "[]", OF _ _ matches_split'(1), simplified])
  apply (frule(5) preservation(1) [where \<tau>s = "[]" and K = "[]", OF _ _ matches_split'(2), simplified])
  apply (erule v_t_funE)
  apply (subgoal_tac "\<exists>r. \<xi>\<^sub>p , [v] \<turnstile> specialise ts' expr \<Down> r \<and> rsv = rename_val rename (monoval r)")
   apply (fastforce intro: v_sem_v_sem_all.v_sem_app)
  apply (force intro!: IH3 simp: matches_def)
  done
  next
  case (v_sem_abs_app \<xi> re f ts e' rv rv' \<gamma> e \<tau> \<Gamma>)
  note IH1  = this(2)
  and  IH2  = this(4)
  and  rest = this(1,3,5-)
  from rest show ?case 
  apply (case_tac e, simp_all)
  apply (clarsimp)
  apply (erule typing_appE)
  apply (rename_tac \<Gamma>1 \<Gamma>2 t)
  apply (cut_tac IH1[OF _ _ _ _ _ _ matches_split'(1)], simp_all)
  apply clarsimp
  apply (rename_tac fv)
  apply (subgoal_tac "\<xi> f rv rv'")
   apply (case_tac fv, simp_all)
  apply (rename_tac f' ts')
  apply (cut_tac IH2[OF _ _ _ _ _ _ matches_split'(2)], simp_all)
  by (fastforce intro: v_sem_v_sem_all.v_sem_abs_app simp: rename_mono_prog_def)
 qed

end

end
