
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="mg.cnaps.compta.ComptaEcriture" %>
<%@ page import="mg.cnaps.compta.ecriture.ComptaEcritureLib" %>
<%@page import="utilitaire.ConstanteEtat"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    try{
    ComptaEcritureLib f = new ComptaEcritureLib();
    f.setNomTable("COMPTA_ECRITURE_FICHE_V2");
    PageConsulte pc = new PageConsulte(f, request, u);
    pc.setTitre("D&eacute;tail Compta Ecriture");
    f=(ComptaEcritureLib)pc.getBase();
    request.setAttribute("ComptaEcriture", f);
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("Id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("dateComptable").setLibelle("Date Comptable");
    pc.getChampByName("dateComptable").setVisible(false);
   pc.getChampByName("designation").setLibelle("Libell&eacute;");
    pc.getChampByName("dateComptable").setLibelle("Date Comptable");
    pc.getChampByName("journal").setLibelle("ID Journal");
    pc.getChampByName("journalLib").setLibelle("Code Journal");
    pc.getChampByName("journalLib").setLien(request.getContextPath() + "/pages/module.jsp?but=compta/ecriture/apresOrigine.jsp", "id=");
    pc.getChampByName("journalDesce").setLibelle("Nom journal");
        pc.getChampByName("idobjet").setLibelle("Ref. source");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        pc.getChampByName("source").setLibelle("Source");
        pc.getChampByName("piece").setLibelle("Num&eacute;ro de la facture");
        pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
        pc.getChampByName("tierslib").setLibelle("Tiers");
        pc.getChampByName("dateSaisie").setLibelle("Date de Saisie");
        pc.getChampByName("dateModif").setLibelle("Date de Modification");
        pc.getChampByName("idModificateurlib").setLibelle("Nom du modificateur");
        pc.getChampByName("idModificateur").setVisible(false);
    pc.getChampByName("dateSaisie").setLibelle("Date de saisie");

    pc.getChampByName("journal").setVisible(false);
//     pc.getChampByName("dateSaisie").setVisible(false);
    pc.getChampByName("remarque").setVisible(false);
	pc.getChampByName("horsExercice").setVisible(false);
    pc.getChampByName("od").setVisible(false);
    pc.getChampByName("origine").setVisible(false);
    pc.getChampByName("credit").setVisible(false);
	pc.getChampByName("debit").setVisible(false);
    pc.getChampByName("idUser").setVisible(false);
    pc.getChampByName("periode").setVisible(false);
    pc.getChampByName("trimestre").setVisible(false);
    pc.getChampByName("periode").setVisible(false);
    pc.getChampByName("annee").setVisible(false);
    pc.getChampByName("lien").setVisible(false);
    pc.getChampByName("lettrage").setVisible(false);
    String[] ordre = {"daty", "dateSaisie", "exercice", "tierslib", "piece", "reference", "idobjet", "source", "designation", "journalLib", "journalDesce", "dateModif", "idModificateurlib", "etat"};
    pc.setOrdre(ordre);

    //pc.getChampByName("idobjet").setVisible(false);
    
    
    String pageActuel = "compta/ecriture/ecriture-fiche.jsp";

    String lien = (String) session.getValue("lien");
    String pageModif = "compta/ecriture/saisie-ecriture-multiple.jsp";
    String classe = "mg.cnaps.compta.ComptaEcriture";
    pc.getChampByName("idobjet").setLien(lien+"?but=compta/ecriture/apresOrigine.jsp", "id=");
    pc.getChampByName("journal").setLien(lien+"?but=compta/journal/journal.jsp", "id=");
    Map<String, String> map = new HashMap<String, String>();
    map.put("/../../historique/inc/historique-liste", "");
    map.put("inc/sous-ecriture-detail", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/sous-ecriture-detail";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
 

%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=compta/ecriture/ecriture-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-12 mb-5 nopadding">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <% if (f.getEtat() < ConstanteEtat.getEtatValider()) { %>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=compta/ecriture/ecriture-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <% }  %>
                             <%if(f.getEtat() >= ConstanteEtat.getEtatValider()){ %>
                                 <% 
                                 if ("chef_comptable".equalsIgnoreCase(u.getUser().getIdrole())) { %>
                               <a class="btn btn-danger pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=annulerVisa&id=" + request.getParameter("id") + "&bute=compta/ecriture/ecriture-fiche.jsp&classe=" + classe %>" style="margin-right: 10px">Annuler visa</a>                            
                                 <%}%>
                             <%}%>
                           
                       </div>
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
                    <li class="<%=map.get("inc/sous-ecriture-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/sous-ecriture-detail">Détails</a></li>
                    <li class="<%=map.get("../../historique/inc/historique-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=../../historique/inc/historique-liste">Historique</a></li>


                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idFactureFournisseur" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>                    
</div>
</div>
</div>

<% } catch(Exception e) { 
    e.printStackTrace();
    throw e;
} %>