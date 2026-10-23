
<%@page import="java.sql.Connection"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="paie.employe.EmployeComplet2" %>
<%@ page import="paie.log.LogPersonnelNonValide" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="paie.employe.EmployeComplet" %>
<%@ page import="historique.MapUtilisateur" %>
<style>
    .ordonnance {
        padding: 0px 35px !important;
    }
</style>
<%!
    EmployeComplet2 pers;
    UserEJB u;
    String patient = "";
    String id = null;
%>
<%
    patient = request.getParameter("id");
    u = (UserEJB) session.getAttribute("u");
    pers = new EmployeComplet2();
    pers.setNomTable("EMPLOYE_COMPLET_LIBELLE2");
    PageConsulte pc = new PageConsulte(pers, request, (user.UserEJB) session.getValue("u"));
    
    // String[] ordre = { "nom", "prenom", "matricule", "sexe", "date_naissance", "lieu_naissance_commune", "situation_matrimonial", "acte_naissance", "nbenfant", "numero_cin", "date_cin", "date_dupl_cin", "lieu_delivrance_cin", "adresse", "telephone", "mail", "region", "service", "idfonction", "idcategorie", "dateembauche", "numero_cnaps", "numero_ostie", "mode_paiement", "banque_numero_compte", "formation", "anneeExperience", "etat"};


    id = request.getParameter("id") != null ? request.getParameter("id") : "";
    id = request.getParameter("idPersonnel") != null ? request.getParameter("idPersonnel") : id;

    String image = "";
    pers = (EmployeComplet2) pc.getBase();

//    pc.getChampByName("deceslib").setValeur("<b style='color: red;'>"+benef.getDeceslib()+"</b>");
//    pc.getChampByName("deceslib").setLibelle(" ");
//    if(benef.getDeces() == 0){
//        pc.getChampByName("deceslib").setVisible(false);
//    }

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
    pc.getChampByName("adresse");
    pc.getChampByName("acte_naissance").setLibelle("Nom Du Ou De La Conjoint(e) L&eacute;gale");
    pc.getChampByName("situation_matrimonial").setLibelle("Situation matrimoniale");
    pc.getChampByName("direction").setLibelle("R&eacute;gion");
    pc.getChampByName("service").setLibelle("Service");
    pc.getChampByName("idfonction").setLibelle("Fonction");
    pc.getChampByName("idcategorie").setLibelle("Classification");
    pc.getChampByName("indicegrade").setLibelle("Indice");
    pc.getChampByName("mode_paiement").setLibelle("Mode de paiement");
    pc.getChampByName("banque_numero_compte").setLibelle("RIB ou Num&eacute;ro Mobile Money");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("dateembauche").setLibelle("Date d'embauche");
    pc.getChampByName("echelon").setLibelle("Niveau");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("date_dernierpromo").setVisible(false);
    pc.getChampByName("echelon").setVisible(false);
    pc.getChampByName("numero_cnaps").setLibelle("Num&eacute;ro CNAPS");
    pc.getChampByName("numero_ostie").setLibelle("Num&eacute;ro OSTIE/OMSIE");
    pc.getChampByName("nbenfant").setLibelle("Enfant(s) &agrave; charge");

    pc.getChampByName("motif_debauche").setLibelle("Motif de d&eacute;bauche");
    pc.getChampByName("type_debauche").setLibelle("Type de d&eacute;bauche");

    pc.getChampByName("adresse_ligne1").setVisible(false);
    pc.getChampByName("adresse_ligne2").setVisible(false);
    pc.getChampByName("mail").setLibelle("Adresse e-mail");
    pc.getChampByName("telephone").setLibelle("T&eacute;l&eacute;phone");
    pc.getChampByName("region").setLibelle("R&eacute;gion");
    pc.getChampByName("anneeExperience").setLibelle("Ann&eacute;e d'experience");
    pc.getChampByName("discipline").setLibelle("Discipline");
    pc.getChampByName("formation").setLibelle("Formation/dipl&ocirc;me");
    pc.getChampByName("code_postal").setLibelle("Code postal");
    pc.getChampByName("categoriePaieLib").setLibelle("Cat&eacute;gorie");
//    pc.getChampByName("temporaire_lib").setVisible(false);
    pc.getChampByName("temporaire_lib").setLibelle("Type de contrat");
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

    String lien = (String) session.getValue("lien");
    LogPersonnelNonValide lpnv = new LogPersonnelNonValide();
    lpnv.setIdlogpers(id);
    lpnv.setNomTable("DERNIER_DEBAUCHE_LPNV");
    LogPersonnelNonValide[] liste_lpnv = (LogPersonnelNonValide[]) CGenUtil.rechercher(lpnv, null, null, " and etat=11 order by date_decision ");
    boolean isLPNV = (liste_lpnv!=null && liste_lpnv.length>0 || pers.getEtat()==utilitaire.ConstanteEtatPaie.getPaieInfoPersonnelDebauche());

    String pageActuel = "paie/employe/personnel-fiche-portrait.jsp";
    String matricule = pers.getMatricule();


    configuration.CynthiaConf.load();
//    String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
//    BeneficiaireFicheData data = new BeneficiaireFicheData("sig_personnes12", "med_hospitalisation_libelle1", "MED_ACTEHOSP_LIBELLE", "MED_BENEFICIAIRE_PJ", "MED_HOSPITALISATION_PJ_PATIENT", patient);
//    if (data.getFichierClient() != null && data.getFichierClient().length > 0) {
//        for (UploadPj element : data.getFichierClient()) {
//            if (element.getChemin().compareTo(patient + ".jpg") == 0 || element.getChemin().compareTo(patient + ".png") == 0) {
//                image = element.getChemin();
//            }
//        }
//    }
//    String nom = benef.getNom() + " " + benef.getPrenom();
//    MedBeneficiaireComplet[] famille = data.getFamille();
//
//    //benef.checkRetraite(null, String.valueOf(u.getUser().getRefuser()));
//    pc.getChampByName("retraite").setValeur(benef.getRetraite());
    /*Onglets*/
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/absence", "");
    map.put("inc/sanction", "");
    map.put("inc/enfant", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/absence";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    UserEJB ue = (UserEJB) session.getValue("u");
//    EmployeComplet pers = new EmployeComplet();
    MapUtilisateur mapUser = ue.getUser();
%>

<style>
    .box-footer {
        padding: var(--Bases-4-space-4);
    }#fiche_patient {
        border-radius: var(--Bases-4-space-2);
    }
    .row.attache-fichier {
        margin: 0;
    }
    #fiche_patient .row {
        padding: var(--Bases-4-space-5);
    }
    #fiche_patient .row:nth-child(2) {
        padding-top: 0;
    }
    .tab-content .box-body .no-data-msg{
        padding-left: var(--Bases-4-space-4);
    }

</style>

<div class="content-wrapper">
    <h1 class="box-title">Fiche du Personnel</h1>
    <div class="row m-0">
        <!--<div class="col-md-3" style="text-align: right;">-->
        <!--<img src="/dossier/patient/<%=image%>" style="width: 50%;margin-top: 30px;box-shadow: 5px 5px 5px #868686;">-->
        <!--</div>-->
        <div class="col-md-12 nopadding mb-5">
            <div class="box">
                <!-- pc apj -->
                <div class="box-body mb-5" id="fiche_patient">
                    <div class="row m-0">
                        <div class="col-md-3">
                            <img src="../assets/img/woman.jpg" style="width: 100%;">

                        </div>
                        <div class="col-md-9">
                            <%
                                out.println(pc.getHtml());
                            %>
                        </div>

                    </div>
                    <br/>

                    <div class="box-footer">
                        <a class="btn btn-primary pull-right"  href="<%= lien + "?but=paie/contrat/contrat_travail.jsp&matricule="+ matricule %>" style="margin-right: 10px">Contrat</a>
                        <% if(pers.getEtat() < 11) {
                             if (mapUser.getIdrole().compareToIgnoreCase("rh") == 0 || mapUser.getIdrole().compareToIgnoreCase("admin") == 0 || mapUser.getIdrole().compareToIgnoreCase("dg") == 0 || mapUser.getIdrole().compareToIgnoreCase("superadmin") == 0) { %>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=paie/categorie/categoriequalification-saisie.jsp&id="+ id %>" style="margin-right: 10px">Saisir Salaire</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=paie/employe/infopersonnel-saisie.jsp&id=" +id+"&acte=update" %>" style="margin-right: 10px">Modifier info profesionnelle</a>

<%--                            <% if (pers.getEtat() != 11) { %>--%>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=apresTarif.jsp&id=" + request.getParameter("id")%>&acte=valider&bute=paie/employe/personnel-fiche-portrait.jsp&classe=paie.employe.PaieInfoPersonnel" style="margin-right: 10px">Viser</a>
<%--                            <% } %>--%>
                            <% }
                        } %>
                        <!-- <a class="btn btn-success"  href="<%= lien + "?but=paie/contrat/contrat-fiche.jsp&id="+ id %>" style="margin-right: 10px">Contrats</a> -->
                        <a class="btn btn-tertiary pull-right"  href="<%= lien + "?but=paie/demande/mademande.jsp&id="+ id %>" style="margin-right: 10px">Saisir Absence</a>
                        <%if (mapUser.getIdrole().compareToIgnoreCase("rh") == 0){%>
                        <a class="btn btn-danger pull-left"  href="<%= lien + "?but=apresTarif.jsp&id=" + id %>&acte=delete&bute=paie/employe/infopersonnel-liste.jsp&classe=paie.log.LogPersonnel" style="margin-right: 10px">Supprimer</a>
                        <% } %>
                        <%
                            if (pers.getEtat() == 11) {
                                if (mapUser.getIdrole().compareToIgnoreCase("rh") == 0 || mapUser.getIdrole().compareToIgnoreCase("admin") == 0 || mapUser.getIdrole().compareToIgnoreCase("dg") == 0 || mapUser.getIdrole().compareToIgnoreCase("superadmin") == 0) { %>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=paie/categorie/categoriequalification-saisie.jsp&id="+ id %>" style="margin-right: 10px">Saisir Salaire</a>
                                <a class="btn btn-secondary pull-left"  href="<%= lien + "?but=paie/employe/infopersonnel-saisie.jsp&id=" +id+"&acte=update" %>" style="margin-right: 10px">Modifier info profesionnelle</a>
                                <!--<a class="btn btn-warning pull-right"  href="<%= lien + "?but=paie/employe/personnel-modif.jsp&id=" + id %>" style="margin-right: 10px">Modifier</a>-->

                                <div class="divider"></div>
                                <a class="btn btn-tertiary pull-right"  href="<%= lien + "?but=paie/employe/personnelnonvalide-saisie.jsp&id=" + id %>" style="margin-right: 10px">D&eacute;part</a>
                                <a class="btn btn-tertiary pull-right"  href="<%= lien + "?but=paie/avancement/avancement-saisie.jsp&id=" + id %>" style="margin-right: 10px">Mouvement</a>
                                <a class="btn btn-tertiary pull-right"  href="<%= lien + "?but=paie/employe/enfantpersonne-saisie.jsp&id=" + id %>" style="margin-right: 10px">Assigner enfant
                                </a>
                        <%
                         }
                     } else {
                        %>
                        <% if(isLPNV){%>
                        <a class="btn btn-tertiary pull-left"  href="#" style="margin-right: 10px" onclick="alert('Personnel d&eacute;j&agrave; parti(e)\nID D&eacute;part : <%if(liste_lpnv.length>0) out.print(liste_lpnv[0].getId()); else out.print("Inconnu");%>');">D&eacute;part</a>
                        <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=paie/employe/personnel-modif.jsp&id=" + id %>&type=0" style="margin-right: 10px">R&eacute;embaucher</a>
                        <% }
                        } %>
                        <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + id  + "&dossier=" + pc.getBase().getClass().getSimpleName() + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + id %>" style="margin-right: 10px;">Attacher Fichier</a>
                    </div>



                </div>
            </div>
        </div>
    </div>
    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("inc/absence")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/absence">Absence</a></li>
                    <li class="<%=map.get("inc/conge")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/conge">Cong&eacute;</a></li>
                    <li class="<%=map.get("inc/info")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/info">Informations personnelles</a></li>
                    <li class="<%=map.get("inc/contrat")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/contrat">Contrat de travail</a></li>
                    <!--<li class="<%=map.get("inc/etat")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/etat">Etat </a></li>-->
<%--                    <li class="<%=map.get("inc/historique")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/historique">Historique </a></li>--%>
                    <li class="<%=map.get("inc/editionmoisannee")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/editionmoisannee">Edition mois ann&eacute;e </a></li>
                    <li class="<%=map.get("inc/sanction")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/sanction">Sanction </a></li>
                    <li class="<%=map.get("inc/enfant")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/enfant">Liste des enfants du personnel</a></li>
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

<%--<script type="text/javascript">--%>
<%--    $(document).ready(function () {--%>

<%--        $('.tree').treegrid({--%>
<%--            expanderExpandedClass: 'glyphicon glyphicon-minus',--%>
<%--            expanderCollapsedClass: 'glyphicon glyphicon-plus'--%>
<%--        });--%>

<%--    });--%>
<%--</script>--%>

