<%@page import="vente.CaJournalier"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.util.Map" %>
<%@page import="affichage.*"%>

<% try{
    CaJournalier f = new CaJournalier();
    f.setNomTable("CA_MENSUEL");
    String listeCrt[] = {"annee","mois"};
    String listeInt[] = {"mois"};
    String libEntete[] = {"annee","moislib","montant"};
    PageRecherche pr = new PageRecherche(f, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste ca mensuel");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/analyse/camensuel.jsp");

    //pr.getFormu().getChamp("annee1").setLibelle("Annee min");
//    pr.getFormu().getChamp("daty1").setLibelle("Date min");
//    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    affichage.Champ[] liste = new affichage.Champ[2];
    Liste listeMois = new Liste("mois1");
    listeMois.makeListeMois();
    liste[0] = listeMois;

    Liste listeMois2 = new Liste("mois2");
    listeMois2.makeListeMois();
    liste[1] = listeMois2;

    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("mois1").setLibelle("mois min");
    pr.getFormu().getChamp("mois2").setLibelle("mois max");
    pr.getFormu().getChamp("annee").setLibelle("ann&eacute;e");
    pr.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
    // pr.getFormu().getChamp("mois").setDefaut(Utilitaire.getMoisEnCoursReel()+"");
    //pr.getFormu().getChamp("mois").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = {"montant"};
    pr.creerObjetPage(libEntete, colSomme);
    String libEnteteAffiche[] = {"Ann&eacute;e","Mois","Montant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <%--        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">--%>
        <%--            <%--%>
        <%--                out.println(pr.getFormu().getHtmlEnsemble());--%>
        <%--            %>--%>
        <%--        </form>--%>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>

        <%
            }catch(Exception e){

                e.printStackTrace();
            }
        %>

        <%
            String anneeGrapheParam = request.getParameter("anneeGraphe");
            String moisGrapheParam = request.getParameter("moisGraphe");

            int anneeGraphe = (anneeGrapheParam != null && !anneeGrapheParam.isEmpty())
                    ? Integer.parseInt(anneeGrapheParam)
                    : Integer.parseInt(Utilitaire.getAnneeEnCours());
            int moisGraphe = (moisGrapheParam != null && !moisGrapheParam.isEmpty())
                    ? Integer.parseInt(moisGrapheParam)
                    : 0;

            Map<String, Double> caMensuel = vente.GrapheCaJournalier.getDataChartCaMensuel(anneeGraphe);
        %>


        <%
            String[] moisNoms = new java.text.DateFormatSymbols(java.util.Locale.FRENCH).getMonths();
            String moisNom = (moisGraphe > 0) ? moisNoms[moisGraphe - 1] : "";
        %>

        <div class="cardradius">
            <form  action="<%=(String)session.getAttribute("lien") %>?but=vente/analyse/camensuel.jsp" method="post">
                <div class="d-flex" style="align-items: end;gap: 8px">
                    <!-- Année -->
                    <div class="col-md-2 nopadding">
                        <label for="anneeGraphe" class="form-label">Ann&eacute;e</label>
                        <input type="number" id="anneeGraphe" name="anneeGraphe" class="form-control"
                               value="<%= (request.getParameter("anneeGraphe") != null && !request.getParameter("anneeGraphe").isEmpty())
                            ? request.getParameter("anneeGraphe")
                            : Utilitaire.getAnneeEnCours() %>">
                    </div>

                    <!-- Bouton -->
                    <div class="col-md-2 nopadding d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100 btn-small">Appliquer</button>
                    </div>
                </div>
            </form>
            <div class="card-body">
                <canvas id="c_ca_journalier"></canvas>
                <h5 class="card-title text-center">
                    CA mensuel
                    <% if (moisGraphe > 0) { %>
                    (<%= moisNom %> <%= anneeGraphe %>)
                    <% } else { %>
                    (Ann&eacute;e <%= anneeGraphe %>)
                    <% } %>
                </h5>
            </div>
        </div>

        <%
            affichage.Graphe g = new affichage.Graphe(new Map[]{caMensuel}, "CA",
                    new String[]{""}, new String[]{""}, "c_ca_journalier", "");
            g.setTypeGraphe("bar"); // courbe
            g.setCouleurs(utils.ConstanteAsync.couleurs);
            g.setBgCouleurs(utils.ConstanteAsync.couleurs);
            out.println(g.getHtml("ctx_caj"));
        %>

    </section>
</div>
