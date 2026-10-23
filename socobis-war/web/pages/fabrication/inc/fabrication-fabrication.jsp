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
        t.setNomTable("FabricationFilleCpl");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "lanceparLib", "cibleLib", "remarque", "libelle", "daty"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        Of o = new Of();
        o.setId(request.getParameter("id"));

        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);

        Map<String,String> lienTab=new HashMap();
        lienTab.put("Valider",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=fabrication/fabrication-fiche.jsp&classe=fabrication.Fabrication&nomtable=fabrication");
        pr.getTableau().setLienClicDroite(lienTab);

        pr.getTableau().setData(o.getFabrication(null,null));
        pr.getTableau().transformerDataString();
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=fabrication/fabrication-fiche.jsp"};
        String colonneLien[] = {"id"};
        String[] attributLien = {"id"};
        String colonneModal[] = {"id"};
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setModalOnClick(true,colonneModal);
        String libEnteteAffiche[] = {"ID", "Lanc&eacute; par", "Cible", "Remarque", "D&eacute;signation", "Date"};
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