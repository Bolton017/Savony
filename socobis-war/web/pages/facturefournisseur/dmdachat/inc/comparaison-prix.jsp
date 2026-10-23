<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 02/06/2026
  Time: 16:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurDetailsCpl" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%
    try {
        ProformaFournisseurDetailsCpl t = new ProformaFournisseurDetailsCpl();
        t.setNomTable("comparaisonprixproforma");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"fournisseurLib", "dateEcheance", "pu", "remise", "remiseMontant", "tva", "montantTTC", "etatLib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if (request.getParameter("id") != null) {
            pr.setAWhere(" and IDORIGINEMERE='" + request.getParameter("id") + "'");
        }

        HashMap<String, Vector> tab = t.comparaisonPrixParProduit(request.getParameter("id"), "comparaisonprixproforma", null);
        String[] colSomme = null;
        String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/dmdachat/selection-proforma.jsp&iddmdachat="+request.getParameter("id")};
        String colonneLien[] = {"pu"};
        String attributLien[] = {"idPF"};
        String valeurLien[] = {"id"};

%>

<div class="box-body">
    <% if (tab.isEmpty()) { %>
        <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <% } else { %>
        <%
            String libEnteteAffiche[] = {"Fournisseur", "Date d'&eacute;ch&eacute;ance de paiement", "Prix Unitaire", "Remise (%)", "Remise en montant", "TVA (%)", "Montant TTC", "Choix"};
            for (String cle : tab.keySet()) {
                Vector<ProformaFournisseurDetailsCpl> data = tab.get(cle);
                ProformaFournisseurDetailsCpl[] dataArray = new ProformaFournisseurDetailsCpl[data.size()];
                data.copyInto(dataArray);
                pr.creerObjetPage(libEntete, colSomme);
                pr.getTableau().setLien(lienTableau);
                pr.getTableau().setColonneLien(colonneLien);
                pr.getTableau().setAttLien(attributLien);
                pr.getTableau().setValeurLien(valeurLien);
                pr.getTableau().setLibelleAffiche(libEnteteAffiche);
                pr.getTableau().setData((bean.ClassMAPTable[]) dataArray);

                pr.getTableau().transformerDataString();

                if (pr.getTableau().getHtml() != null) {
                    out.println("<h2>" + cle + "</h2>");
                    out.println(pr.getTableau().getHtml());
        }
            if (pr.getTableau().getHtml() == null) {
        %>
        <center><h4>Aucune donnee trouvee</h4></center>
        <%
                }
            }
        %>
    <% } %>
</div>
<%--<%=pr.getModalHtml("modalContent")%>--%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
