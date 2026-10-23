<%@page import="paie.log.LogPersonnelNonValide"%>
<%@page import="paie.log.SigPersonnes"%>
<%@page import="utilitaire.ConstanteEtatPaie"%>
<%@page import="bean.CGenUtil"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="paie.employe.EmployeComplet2"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%!
    EmployeComplet2 personnel;
    PageConsulte pc;
    UserEJB u = null;
    String lien = null;
    String id = null;
%>
<%
    try {
        id = (request.getParameter("id") == null || request.getParameter("id").compareToIgnoreCase("") == 0) ? "" : request.getParameter("id");
        if (id.startsWith("PEP")) {
            id = (request.getParameter("idpersonnel") == null || request.getParameter("idpersonnel").compareToIgnoreCase("") == 0) ? "" : request.getParameter("idpersonnel");
        }
        u = (UserEJB) session.getAttribute("u");
        lien = (String) session.getValue("lien");
        personnel = new EmployeComplet2();
        personnel.setNomTable("EMPLOYE_COMPLET_LIBELLE2");
        pc = new PageConsulte(personnel, request, (user.UserEJB) session.getValue("u"));
        personnel = (EmployeComplet2) pc.getBase();
        pc.setTitre("Fiche personnel");
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("nom").setLibelle("Nom");
        pc.getChampByName("prenom").setLibelle("Pr&eacute;nom(s)");
        pc.getChampByName("matricule").setLibelle("Matricule");
        pc.getChampByName("date_naissance").setLibelle("Date de naissance");
        pc.getChampByName("lieu_naissance_commune").setLibelle("Lieu de naissance");
        pc.getChampByName("sexe").setLibelle("Genre");
        pc.getChampByName("numero_cin").setLibelle("Num&eacute;ro CIN");
        pc.getChampByName("date_cin").setLibelle("Date de d&eacute;livrance CIN");
        pc.getChampByName("lieu_delivrance_cin").setLibelle("Lieu de d&eacute;livrance CIN");
        pc.getChampByName("date_dupl_cin").setLibelle("Date de duplicata CIN");
        pc.getChampByName("adresse").setVisible(false);
        pc.getChampByName("acte_naissance").setLibelle("Acte de mariage");
        pc.getChampByName("situation_matrimonial").setLibelle("Situation matrimoniale");
        pc.getChampByName("direction").setLibelle("Affectation");
        pc.getChampByName("service").setLibelle("Service");
        pc.getChampByName("idfonction").setLibelle("Fonction");
        pc.getChampByName("idcategorie").setLibelle("Classification");
        pc.getChampByName("indicegrade").setLibelle("Indice");
        pc.getChampByName("mode_paiement").setLibelle("Mode de paiement");
        pc.getChampByName("banque_numero_compte").setLibelle("RIB ou Numéro Mobile Money");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("dateembauche").setLibelle("Date d'embauche");
        pc.getChampByName("echelon").setLibelle("Niveau");
        pc.getChampByName("etat").setLibelle("Etat");
        pc.getChampByName("date_dernierpromo").setLibelle("Derni&egrave;re promotion");
        pc.getChampByName("numero_cnaps").setLibelle("Num&eacute;ro CNAPS");
        pc.getChampByName("numero_ostie").setLibelle("Num&eacute;ro OSTIE/OMSIE");
        pc.getChampByName("nbenfant").setLibelle("Enfant(s) &agrave; charge");
//        pc.getChampByName("sexe").setLibelle("Genre");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        pc.getChampByName("categoriePaieLib").setLibelle("Cat&eacute;gorie");

        pc.getChampByName("motif_debauche").setLibelle("Motif d&eacute;bauche");
        pc.getChampByName("type_debauche").setLibelle("Type d&eacute;bauche");

        pc.getChampByName("adresse_ligne1").setLibelle("Adresse");
        pc.getChampByName("adresse_ligne2").setVisible(false);
        pc.getChampByName("mail").setLibelle("Adresse E-mail");
        pc.getChampByName("telephone").setLibelle("T&eacute;l&eacute;phone");
        pc.getChampByName("region").setLibelle("R&eacute;gion");
        pc.getChampByName("anneeExperience").setLibelle("Ann&eacute;e d'experience");
        pc.getChampByName("discipline").setLibelle("Discipline");
        pc.getChampByName("formation").setLibelle("Formation/dipl&ograve;me");
        pc.getChampByName("code_postal").setLibelle("Code postal");

        pc.getChampByName("temporaire_lib").setVisible(false);
        pc.getChampByName("region").setVisible(false);
        pc.getChampByName("heurejournalier").setVisible(false);
        pc.getChampByName("heurejournalier").setVisible(false);
        pc.getChampByName("heurehebdomadaire").setVisible(false);
        pc.getChampByName("heuremensuel").setVisible(false);

        pc.getChampByName("idcategorie").setVisible(false);
        pc.getChampByName("id_pers").setVisible(false);
        pc.getChampByName("nationalite").setVisible(false);
        pc.getChampByName("indice_fonctionnel").setVisible(false);
        pc.getChampByName("idconjoint").setVisible(false);
        pc.getChampByName("code_agence_banque").setVisible(false);
        pc.getChampByName("banque_compte_cle").setVisible(false);
        pc.getChampByName("permis_conduire").setVisible(false);
        pc.getChampByName("chemin_permis").setVisible(false);
        pc.getChampByName("cturgence_nom_prenom").setVisible(false);
        pc.getChampByName("cturgence_telephone1").setVisible(false);
        pc.getChampByName("cturgence_telephone2").setVisible(false);
        pc.getChampByName("cturgence_telephone3").setVisible(false);
        pc.getChampByName("datesaisie").setVisible(false);
        pc.getChampByName("banque_code").setVisible(false);
        pc.getChampByName("matricule_patron").setVisible(false);
        pc.getChampByName("banque_compte_cle").setVisible(false);
        pc.getChampByName("vehiculee_str").setVisible(false);
        pc.getChampByName("vehiculee").setVisible(false);
        pc.getChampByName("statut").setVisible(false);
        pc.getChampByName("ctg").setVisible(false);
        pc.getChampByName("classee").setVisible(false);
        pc.getChampByName("temporaire").setVisible(false);
        pc.getChampByName("initiale").setVisible(false);
        pc.getChampByName("fokotany").setVisible(false);

        SigPersonnes resultat_conjoint = null;
        if (personnel.getIdconjoint() != null && personnel.getIdconjoint().compareToIgnoreCase("") != 0) {
            resultat_conjoint = new SigPersonnes();
            resultat_conjoint.setNomTable("SIG_PERSONNE_LIBELLE_KOTO");
            resultat_conjoint.setId(personnel.getIdconjoint());
            SigPersonnes[] rstTmp = ((SigPersonnes[]) u.getData(resultat_conjoint, null, null, null, " and id='" + personnel.getIdconjoint() + "'"));
            if (rstTmp.length > 0) {
                resultat_conjoint = rstTmp[0];
            }
        }

        LogPersonnelNonValide lpnv = new LogPersonnelNonValide();
        lpnv.setIdlogpers(id);
        lpnv.setNomTable("DERNIER_DEBAUCHE_LPNV");
        LogPersonnelNonValide[] liste_lpnv = (LogPersonnelNonValide[]) CGenUtil.rechercher(lpnv, null, null, " and etat=11 order by date_decision ");
        boolean isLPNV = (liste_lpnv!=null && liste_lpnv.length>0 || personnel.getEtat()==utilitaire.ConstanteEtatPaie.getPaieInfoPersonnelDebauche());

        String pageActuel = "paie/employe/personnel-fiche.jsp";
        /*Onglets*/
        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/absence", ""); 

        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/absence";
        } 
        map.put(tab, "active");
        tab = tab + ".jsp";
        String matricule = personnel.getMatricule();

%>

<div class="content-wrapper">

    <h1 class="box-title"><a href=<%= lien + "?but=paie/employe/infopersonnel-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a>Fiche Personnel</h1>
    <div class="row">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                        <div class="box-body">
                            <%
                                out.println(pc.getHtml());
                            %>
                            <br/>
                            <div class="box-footer">
                                <%
                                    if (personnel.getEtat() == 1) {
                                %>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=paie/employe/logPersonnel-modif.jsp&id=" + id%>" style="margin-right: 10px">Modifier etat civil</a>
                                <a class="btn btn-primary pull-right"  href="<%= lien + "?but=apresTarif.jsp&id=" + request.getParameter("id")%>&acte=valider&bute=paie/employe/personnel-fiche.jsp&classe=paie.employe.PaieInfoPersonnel" style="margin-right: 10px">Viser</a>
                                <%
                                    }
                                %>
                                <a class="btn btn-primary pull-right"  href="<%= lien + "?but=paie/contrat/contrat_travail.jsp&matricule="+ matricule %>" style="margin-right: 10px">Contrats</a>
                                <!-- <a class="btn btn-success"  href="<%= lien + "?but=paie/contrat/contrat-fiche.jsp&id="+ id %>" style="margin-right: 10px">Contrats</a> -->
                                <a class="btn btn-primary pull-right"  href="<%= lien + "?but=paie/demande/mademande.jsp&id="+ id %>" style="margin-right: 10px">Saisir Absence</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=paie/employe/infopersonnel-saisie.jsp&id=" +id+"&acte=update" %>" style="margin-right: 10px">Modifier info profesionnelle</a>
                                <%
                                    if (personnel.getEtat()==11) {
                                %>
                                <!--<a class="btn btn-warning pull-right"  href="<%= lien + "?but=paie/employe/personnel-modif.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Modifier</a>-->
                                <a class="btn btn-danger pull-left"  href="<%= lien + "?but=apresTarif.jsp&id=" + request.getParameter("id")%>&acte=delete&bute=paie/employe/infopersonnel-liste.jsp&classe=paie.log.LogPersonnel" style="margin-right: 10px">Supprimer</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=paie/employe/personnelnonvalide-saisie.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">D&eacute;part</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=paie/avancement/avancement-saisie.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Mouvement</a>
                                <%
                                } else {
                                %>
                                <% if(isLPNV){%>
                                <a class="btn btn-secondary pull-right"  href="#" style="margin-right: 10px" onclick="alert('Personnel d&eacute;j&agrave; parti(e)\nID D&eacute;part : <%if(liste_lpnv.length>0) out.print(liste_lpnv[0].getId()); else out.print("Inconnu");%>');">D&eacute;part</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=paie/employe/personnel-modif.jsp&id=" + request.getParameter("id")%>&type=0" style="margin-right: 10px">R&eacute;embaucher</a>
                                <% }
                                } %>
                                <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + pc.getBase().getClass().getSimpleName() + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") %>" style="margin-right: 10px;">Attacher Fichier</a>
                            </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("inc/absence")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/absence">Absence</a></li>
                    <li class="<%=map.get("inc/conge")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/conge">Cong&eacute;</a></li>
                    <li class="<%=map.get("inc/info")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/info">Informations personnelles</a></li>
                    <li class="<%=map.get("inc/contrat")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/contrat">Contrat de travail</a></li>
                    <li class="<%=map.get("inc/frais")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/frais">Frais m&eacute;dicaux</a></li>
                    <!--<li class="<%=map.get("inc/etat")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/etat">Etat </a></li>-->
                    <li class="<%=map.get("inc/historique")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/historique">Historique </a></li>
                    <li class="<%=map.get("inc/editionmoisannee")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/editionmoisannee">Edition mois ann&eacute;e </a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idpersonnel" value="<%= id %>" />
                        <jsp:param name="matricule" value="<%= matricule %>" />
                    </jsp:include>
                </div>
            </div>
        </div>
    </div>
    <%=pc.getHtmlAttacherFichier()%>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>