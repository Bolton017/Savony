<%@page import="rapprochement.RapprochementBC"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    try{
        RapprochementBC t = new RapprochementBC();
        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"id","idSousEcriture","idReleverDetail","valeurSousEcriture","valeurReleverDetail","daty"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        String idmere = request.getParameter("idmere") != null ? request.getParameter("idmere") : request.getParameter("id");
        pr.setAWhere(" AND IDMERE='"+ idmere + "'");
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);

%>

<div class="box-body">
    <%
        String[] lienTableau = {pr.getLien() + "?but=compta/ecriture/sousecriture-fiche.jsp",
                pr.getLien() + "?but=rapprochement/relever-fiche-detail.jsp"};
        String[] colonneLien = {"idSousEcriture","idReleverDetail"};
        String[] attributLien = {"id","id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);


        String[] libEnteteAffiche =  {"ID","ID SOUS ECRITURE","ID RELEV&Eacute;","VALEUR SOUS ECRITURE","VALEUR RELEV&Eacute;","DATE"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center><%
    }

%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>