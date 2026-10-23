<%--
    Document   : liste-fabrication-of
    Created on :  03 avril 2025
    Author     : Safidy
--%>


<%@page import="fabrication.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>


<%
    try{
        FabricationCpl t = new FabricationCpl();
        t.setNomTable("FabricationCpl");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","libelle","remarque","daty","etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setApres("fabrication/ordre-fabrication-details-fiche.jsp&id="+request.getParameter("id"));
            pr.setAWhere(" and IDOFFILLE='"+request.getParameter("id")+"'");
        }

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        Map<String,String> lienTab=new HashMap();
        lienTab.put("Valider",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=fabrication/fabrication-fiche.jsp&classe=fabrication.Fabrication&nomtable=fabrication");
        pr.getTableau().setLienClicDroite(lienTab);

        pr.getTableau().transformerDataString();
        String lienTableau[] = {pr.getLien() + "?but=fabrication/fabrication-fiche.jsp"};
        String colonneLien[] = {"id"};
        String colonneModal[] = {"id"};

        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLienFille("fabrication/inc/fabrication-details.jsp&id=");
        pr.getTableau().setModalOnClick(true,colonneModal);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"id","D&eacute;signation","Remarque","Date","&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPageOnglet());
    %>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

