<%@page import="stock.*"%>
<%@ page import="affichage.*" %>
<%@ page import="demande.DemandeTransfertCpl" %>


<%
    try{
        DemandeTransfertCpl t = new DemandeTransfertCpl();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","designation","idMagasinDepartlib","idMagasinArrivelib","daty","etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and IDOF='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().transformerDataString();
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=demande/demandetransfert-fiche.jsp"};
        String colonneLien[] = {"id"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        String libEnteteAffiche[] = {"id","D&eacute;signation","Magasin de d&eacute;part","Magasin d'arriv&eacute;e","Date","&Eacute;tat"};
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


