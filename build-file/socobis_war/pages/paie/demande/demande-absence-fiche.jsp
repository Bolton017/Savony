<%-- 
    Document   : demande-absence-fiche.jsp
    Created on : 14 juin 2023, 10:25:03
    Author     : Jacques
--%>
<%@page import="user.UserEJB"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="paie.demande.DemandeJustifications"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageConsulte"%>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@page import="service.UploadService"%>
<%@ page import="mg.spat.AttacherFichier" %>


<%
    try{
        
    UserEJB u = (UserEJB) session.getAttribute("u");
        
    String tab = null;
    Map<String, String> map = new HashMap<String, String>();
    map.put("historique", "");

    String id = request.getParameter("id");
    tab = request.getParameter("tab");
    if (tab == null) {
        tab = "historique";
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";   

    DemandeJustifications dem = new DemandeJustifications();
    dem.setNomTable("demande_libcomplet");
    PageConsulte pc = new PageConsulte(dem, request, (user.UserEJB) session.getValue("u"));
    dem = (DemandeJustifications)pc.getBase();

    double avantConge= dem.getAvantResteconge();
    double apresConge= dem.getApresResteconge();

    pc.getChampByName("etatlib").setVisible(false);
    pc.getChampByName("heuredepart").setVisible(false);
    pc.getChampByName("heurearrive").setVisible(false);
    pc.getChampByName("numero").setVisible(false);
    pc.getChampByName("desce").setVisible(false);
    pc.getChampByName("observation").setVisible(false);
    pc.getChampByName("titre").setVisible(false);
    pc.getChampByName("idtypedemande").setVisible(false); 
    pc.getChampByName("horairenormal").setVisible(false);
    pc.getChampByName("idtypeabsence").setVisible(false);
    pc.getChampByName("refuser").setVisible(false);
    pc.getChampByName("idremplacents").setVisible(false);
    pc.getChampByName("nom").setVisible(false);
    pc.getChampByName("prenom").setVisible(false);
    pc.getChampByName("personnel").setLien((String) session.getValue("lien") + "?but=paie/employe/personnel-fiche-portrait.jsp&id=" + dem.getIdpersonnel(), "nom=");
    pc.getChampByName("superieur").setLien((String) session.getValue("lien") + "?but=paie/employe/personnel-fiche-portrait.jsp&id=" + dem.getIdSup(), "nom=");
    pc.getChampByName("typeabsencelib").setLibelle("Type d'absence");
    pc.getChampByName("datedepart").setLibelle("Date de d&eacute;but");
    pc.getChampByName("datefin").setLibelle("Date de fin");
    pc.getChampByName("dateretour").setLibelle("Date de retour");
    pc.getChampByName("duree").setLibelle("Nombre De Jours"); 
    pc.getChampByName("daty").setLibelle("Date de saisie");
    pc.getChampByName("remplacents").setLibelle("rempla&ccedil;ant");
    pc.getChampByName("annuler").setVisible(false);
    pc.getChampByName("idSup").setVisible(false);
    pc.getChampByName("idpersonnel").setVisible(false);
    pc.getChampByName("superieur").setLibelle("Superieur");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("ranguser").setVisible(false);
    pc.getChampByName("superieur").setVisible(false);
    pc.getChampByName("avenant").setVisible(false);
    pc.getChampByName("motifrefu").setLibelle("Motif de refus");
    pc.setTitre("Fiche de la demande d'absence");
    String lien = (String) session.getValue("lien");
    String pageModif = "paie/demande/mademande.jsp";
    DemandeJustifications base = (DemandeJustifications) pc.getBase();
    String classe = "paie.demande.DemandeJustifications";

    mg.spat.AttacherFichier[] fichiers = UploadService.getUploadFile(dem.getId());
    configuration.CynthiaConf.load();
    String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
    cdn = "http://localhost:8080/dossier/";
    String dossier = "absence";
%>
<style>
    #onglets
    {
        font : bold 11px Batang, arial, serif;
        list-style-type : none;
        padding-bottom : 24px; /* � modifier suivant la taille de la police ET de la hauteur de l'onglet dans #onglets li */
        border-bottom : 1px solid #9EA0A1;
        margin-left : 0;
    }

    #onglets li
    {
        float : left;
        height : 21px; /* � modifier suivant la taille de la police pour centrer le texte dans l'onglet */
        background-color: #F4F9FD;
        margin : 2px 2px 0 2px !important;  /* Pour les navigateurs autre que IE */
        margin : 1px 2px 0 2px;  /* Pour IE  */
        border : 1px solid #9EA0A1;
    }

    #onglets li.active
    {
        border-bottom: 1px solid #fff;
        background-color: #fff;
    }

    #onglets a
    {
        display : block;
        color : #666;
        text-decoration : none;
        padding : 4px;
    }

    #onglets a:hover
    {
        background : #fff;
    }
    .col-md-center .box-fiche{
        min-width:100%;
    }
</style>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=paie/demande/demande-absence-liste.jsp"%>> <i class="fa fa-angle-left"></i></a>Fiche de la demande d'absence</h1>
    <div class="row m-0">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if(base.getEtat()== ConstanteEtat.getEtatCreer()){ %>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id="+id+"&acte=update" %>"style="margin-right: 10px">Modifier</a>
                            <%} %>
                            <% if(base.getEtat() <= ConstanteEtat.getEtatValider() && base.getEtat() <= ConstanteEtatPaie.getEtatValiderParCH()){ %>
                            <a class="btn btn-primary pull-right"  href="<%=lien + "?but=apresTarif.jsp&id=" + base.getId()%>&acte=valider&bute=paie/demande/demande-absence-fiche.jsp&id=<%=base.getId()%>&classe=paie.demande.DemandeJustifications" style="margin-right: 10px">Valider</a>
                            <%} %>
                            <% if(base.getEtat()==ConstanteEtat.getEtatCreer()){ %>
                            <a class="btn btn-tertiary pull-right"  href="<%=(String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=paie/demande/demande-absence-fiche.jsp"%>" style="margin-right: 10px">Attacher Fichier</a>
                            <%} %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row m-0">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="">
                    <div class="nav-tabs-custom">
                        <ul class="nav nav-tabs">
                            <li class="<%= map.get("historique")%>"><a href="module.jsp?but=demande/demande-absence-fiche.jsp&id=<%=request.getParameter("id")%>&personnel=<%=dem.getPersonnel()%>&tab=historique">Historique</a></li>
                        </ul>

                        <div class="tab-content">
                           <div class="box-body">
                               <jsp:include page="<%=tab%>">
                                   <jsp:param name="personnel" value="<%=dem.getPersonnel()%>" />
                               </jsp:include>
                           </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%=pc.getHtmlAttacherFichier()%>
</div>
<script>
    $('#fiche .row .col-md-6').removeClass('col-md-6').removeClass('col-md-center').addClass('col-md-8').addClass('col-md-offset-2');
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>




<script language="JavaScript"> alert('<%=e.getMessage()%>');
              history.back();</script>
<%
    return;
}
%>


