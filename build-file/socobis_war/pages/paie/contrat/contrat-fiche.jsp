
<%@page import="paie.contrat.VueContrat"%>
<%@ page import="bean.*" %>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="affichage.PageConsulte" %>

<%
    try{
        String dossier = "op";
        String pageActuel = "paie/contrat/contrat-fiche.jsp";
    VueContrat contrat = new VueContrat();
    PageConsulte pc = new PageConsulte(contrat, request, (user.UserEJB) session.getValue("u"));
    contrat =(VueContrat) pc.getBase();
    pc.setTitre("Fiche du Contrat ");
    
    pc.getChampByName("dateembauche").setLibelle("Date d'embauche");
    pc.getChampByName("periode").setLibelle("Periode d'essai(mois)");
    pc.getChampByName("date_fin_contrat").setLibelle("Date de fin de contrat");
    pc.getChampByName("type_contrat").setLibelle("Type de contrat");
    pc.getChampByName("prenom").setLibelle("Pr&eacute;nom");
    pc.getChampByName("etat").setVisible(false);
  
    String lien = (String) session.getValue("lien");
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=paie/contrat/contrat-liste.jsp"%>> <i class="fa fa-angle-left"></i></a>Fiche du contrat</h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer" >
                            <a class="btn btn-primary pull-right"  href="<%=(String) session.getValue("lien") + "?but=contrat/mouvement-contrat-saisie.jsp&id=" + contrat.getId()%>" style="margin-right: 10px">Modifier contrat</a>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") %>" style="margin-right: 10px;">Attacher Fichier</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%=pc.getHtmlAttacherFichier()%>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>