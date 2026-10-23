<%@page import="stock.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Ingredients" %>

<%
    try{
        MvtStockFilleTheorique t = new MvtStockFilleTheorique();
        t.setNomTable("stockEtDepenseFabThe");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"idproduit","designation","pu","sortie","qteth","Ecartqte","montantsortie","pourcentage","montth","Ecartmontant"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
           pr.setAWhere(" and IDOBJET='"+request.getParameter("id")+"'");
           pr.setApres("fabrication/fabrication-fiche.jsp&id="+request.getParameter("id")+"&tab=inc/fabrication-rapprochement");
        }
        String idCat = request.getParameter("idCat");
        if(idCat != null && !idCat.isEmpty()){
            pr.setAWhere(pr.getAWhere() + " and categorieingredient='" + idCat + "'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        MvtStockFilleTheorique[] listeFille=(MvtStockFilleTheorique[]) pr.getTableau().getData();
        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"idproduit"};
        String attributLien[] = {"id"};
        String colonneModal[] = {"idproduit"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setModalOnClick(true, colonneModal);

        double sortie = AdminGen.calculSommeDouble(listeFille, "sortie");
        double qteth = AdminGen.calculSommeDouble(listeFille, "qteth");

        double montant = AdminGen.calculSommeDouble(listeFille, "montantsortie");
        double montth = AdminGen.calculSommeDouble(listeFille, "montth");

        double ecartqte = AdminGen.calculSommeDouble(listeFille, "Ecartqte");
        double ecartmontant = AdminGen.calculSommeDouble(listeFille, "Ecartmontant");

        String styleQte = sortie > qteth ? "color:red;" : "";
        String styleMontant = montant > montth ? "color:red;" : "";

        String styleEcartQte = ecartqte > 0 ? "color:red;" : "";
        String styleEcartMontant = ecartmontant > 0 ? "color:red;" : "";
        MvtStockFilleTheorique.calculerPourcentage(listeFille);
        pr.getTableau().transformerDataString();
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Ingr&eacute;dient","D&eacute;signation","PU","Quantit&eacute;","Quantit&eacute; Th&eacute;orique", "&Eacute;cart Quantit&eacute;","Montant","% pratique","Montant Th&eacute;orique", "&Eacute;cart montant"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 50%" class="table">
            <tr>

                <td><b>Total Montant Pratique :</b></td>
                <td><b style="<%= styleMontant %>"><%= utilitaire.Utilitaire.formaterAr(montant) %> Ar</b></td>
            </tr>
            <tr>

                <td><b>Total Montant TH:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(montth) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Ecart Montant TH:</b></td>
                <td><b style="<%= styleEcartMontant %>"><%= utilitaire.Utilitaire.formaterAr(ecartmontant) %> Ar</b></td>
            </tr>
        </table>
    </div>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donnee trouvee</h4></center><%
    }
%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

