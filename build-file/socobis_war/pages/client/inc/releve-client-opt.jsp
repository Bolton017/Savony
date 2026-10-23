<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 05/08/2025
  Time: 14:02
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="affichage.PageRecherche" %>
<%@page import="affichage.*"%>
<%@ page import="client.ReleveClient" %>
<%@ page import="client.ReleverClientOpt" %>
<%  try{

    ReleverClientOpt dmd = new ReleverClientOpt();
    String listCrt[] = {};
    String listInt[] = {};
    String libEntete[] = {"id","daty", "libelle", "journal", "lettre", "solde_initial", "debit", "credit", "solde_final"};

    PageRecherche pr = new PageRecherche(dmd, request, listCrt, listInt, 3,libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    String[] colSomme = {};
    pr.creerObjetPage(libEntete, colSomme);


    String libEnteteAffiche[] = {"ID","Date", "Libell&eacute;", "Journal", "Lettre","Solde Initial","D&eacute;bit","Cr&eacute;dit","Solde Final"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    if(request.getParameter("id") != null){
        ReleverClientOpt[] releverClientOpts = dmd.getReleverClientOpt(request.getParameter("id"),null);
        pr.getTableau().setData(releverClientOpts);
        pr.getTableau().transformerDataString();
    }
%>
<div class="box-body">
    <%
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><center><h4>Aucune donne trouvé</h4></center><%
    }


%>
</div><%
    }catch(Exception e){
        e.printStackTrace();
    }
%>


