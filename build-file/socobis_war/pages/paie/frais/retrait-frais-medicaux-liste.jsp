<%-- 
    Document   : congeDroit-liste
    Created on : 1 déc. 2020, 09:42:10
    Author     : mariano
--%>

<%@page import="utilitaire.ConstanteEtatPaie"%>
<%@page import="paie.frais.RetraitFraisMedicaux"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="utilitaire.Utilitaire"%>
<% 
    RetraitFraisMedicaux base = new RetraitFraisMedicaux();
    String[] etatVal = {"retrait_frais_medicaux_lib", "retrait_frais_medicaux_lib_cree","retrait_frais_medicaux_lib_valide", "retrait_frais_medicaux_lib_vise"};
    String nomTable = etatVal[0];
    
    String etat = request.getParameter("etat");
    if (etat != null && !etat.trim().isEmpty()) {
        nomTable = etat;
    }
    
    base.setNomTable(nomTable);
    
    String libEntete[] = {"id", "matricule", "idpersonnellib", "description", "daty","montant", "etatlib"};
    String listeCrt[] = {"id", "matricule", "idpersonnellib", "montant", "daty"};
    String listeInt[] = {"montant", "daty"};
    
    PageRecherche pr = new PageRecherche(base, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    pr.getFormu().getChamp("idpersonnellib").setLibelle("Personnel");
    pr.getFormu().getChamp("montant1").setLibelle("Montant min");
    pr.getFormu().getChamp("montant2").setLibelle("Montant max");
    pr.getFormu().getChamp("daty1").setLibelle("Date retrait min");
    pr.getFormu().getChamp("daty2").setLibelle("Date retrait max");
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.setApres("paie/frais/retrait-frais-medicaux-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>
<script>
    function changerDesignation() {
        document.retrait.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des retraits de frais medicaux</h1>
    </section>
    <section class="content">                          
                <form action="<%=pr.getLien()%>?but=paie/frais/retrait-frais-medicaux-liste.jsp" method="post" name="personnel" id="personnel">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="col-md-4"></div>
            <div class="col-md-4">
                <div class="form-group">
                    <label>Etat : </label>
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()" style="display: inline-block; width: 250px;">
                        <option value="" <% if (request.getParameter("etat") == null || request.getParameter("etat").compareToIgnoreCase("") == 0) {
                                out.print(" selected");
                            }%>>Tous</option>
                        <option value="<%=ConstanteEtatPaie.getEtatCreer()%>" <%if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase(ConstanteEtatPaie.getEtatCreer()+"") == 0) {
                                out.print("selected");
                            }%>>Cr&eacute;e</option>
                        <option value="<%=ConstanteEtatPaie.getEtatValiderParDemandeur()%>" <%if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase(ConstanteEtatPaie.getEtatValiderParDemandeur()+"") == 0) {
                                out.print("selected");
                            }%>>Valider par demandeur</option> 
                        <option value="<%=ConstanteEtatPaie.getEtatValiderParCH()%>" <%if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase(ConstanteEtatPaie.getEtatValiderParCH()+"") == 0) {
                                out.print("selected");
                            }%>>Valider par CH</option>
                        <option value="<%=ConstanteEtatPaie.getEtatValiderParDE()%>" <%if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase(ConstanteEtatPaie.getEtatValiderParDE()+"") == 0) {
                                out.print("selected");
                            }%>>Valider par DE</option>
                        <option value="<%=ConstanteEtatPaie.getEtatValiderParDG()%>" <%if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase(ConstanteEtatPaie.getEtatValiderParDG()+"") == 0) {
                                out.print("selected");
                            }%>>Valider par DG</option>
                    </select>
                </div>
            </div>
            <div class="col-md-4"></div>
        </form>
        <%  
            String lienTableau[] = {pr.getLien() + "?but=paie/frais/retrait-frais-medicaux-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            String libEnteteAffiche[] = {"ID", "Matriucle", "Personnel", "Description", "Date de retrait","Montant", "Etat"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>


