<%@ page import="affichage.*" %>
<%@ page import="maintenance.travaux.TravauxFilleCpl" %>


<%
    try{
        TravauxFilleCpl t = new TravauxFilleCpl();
        t.setNomTable("TravauxFilleCpl");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "idIngredients","idingredientsLib","operateurLib", "libelle"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idMere='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().transformerDataString();
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=maintenance/ressources/machine/machine-fiche.jsp"};
        String colonneLien[] = {"idingredients"};
        String[] attributLien = {"id"};
        String colonneModal[] = {"idingredients"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setModalOnClick(true,colonneModal);
        String libEnteteAffiche[] =  {"id", "ID &Eacute;l&eacute;ment","&Eacute;l&eacute;ment","Op&eacute;rateur","Remarque"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
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

