<%@page import="machine.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="maintenance.ressources.IngredientMaintenanceLib" %>


<%
    try{
        IngredientMaintenanceLib t = new IngredientMaintenanceLib();
//        t.setNomTable("MACHINE");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","libelle","etatObjetLib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setApres("ligne/ligne-fiche.jsp&id="+request.getParameter("id"));
            pr.setAWhere(" and IDLIGNE='"+request.getParameter("id")+"'");
        }

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        String lienTableau[] = {pr.getLien() + "?but=maintenance/ressources/machine/machine-fiche.jsp"};
        String colonneLien[] = {"id"};
        String colonneModal[] = {"id"};

        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setModalOnClick(true,colonneModal);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"id","Nom","&Eacute;tat"};
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

