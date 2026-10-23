<%-- 
    Document   : salaire-saisie
    Created on : 28 janv. 2021, 14:12:19
    Author     : Sanda
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.CGenUtil"%>
<%@page import="paie.log.LogService"%>
<%@page import="bean.TypeObjet" %>

<%
    
    try {
    String lien = (String) session.getValue("lien");
    
    TypeObjet direction,categorie, lsDirection[];
    direction = new TypeObjet();
    categorie = new TypeObjet();
    direction.setNomTable("log_direction");
    lsDirection = (TypeObjet[]) CGenUtil.rechercher(direction, null, null, "");
    


    categorie.setNomTable("CATEGORIE_PAIE_SALAIRE");  // ton view
    TypeObjet[] lsCategorie = (TypeObjet[]) CGenUtil.rechercher(categorie, null, null, "");
    /*
    LogService temp = new LogService();
    temp.setNomTable("log_service");
    LogService[] rattachement=(LogService[])CGenUtil.rechercher(temp, null, null, null, "");
    */   
    
    String affiche[] = {"Janvier", "F&eacute;vrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "D&eacute;cembre"};
    String valeur[] = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"};     
    int tailleMois = affiche.length;

%>

<div class="content-wrapper">
    <h1 align="center">G&eacute;n&eacute;rer Salaire</h1>
    <form action="<%=lien%>?but=apresSpecifique.jsp" method="post" name="salaire" id="salaire" data-parsley-validate>
        <div class="col-md-12 cardradius">
            <div class="input-container">
                <div class="form-input">
                    <label class="input-label" for="mois">Mois</label>
                    <span class="col-md-12 row nopadding">
                        <select id="mois" class="form-control" tabindex="1" name="mois" data-parsley-id="1">
                            <%for (int i = 0; i < tailleMois; i++) {%>
                                <option value="<%=valeur[i]%>"><%=affiche[i]%></option>
                            <% }%>
                        </select>
                    </span>
                </div>
                <div class="form-input">
                    <label class="input-label" for="annee">Ann&eacute;e</label>
                    <span class="col-md-12 row nopadding">
                        <input id="annee" class="form-control" value="<%=Utilitaire.getAnneeEnCours()%>" type="text" tabindex="5" name="annee" data-parsley-id="5">
                    </span>
                </div>
                <div class="form-input">
                    <label class="input-label" for="rattachement">Rattachement</label>
                    <select id="rattachement" class="form-control" tabindex="1" name="rattachement" data-parsley-id="1">
                        <%for (TypeObjet r : lsDirection) {%>
                        <option value="<%=r.getId()%>"><%=r.getVal()%></option>
                        <% }%>
                    </select>
                </div> 
                <div class="form-input">
                    <label class="input-label" for="categorie">Cat&eacute;gorie</label>
                    <select id="categorie" class="form-control" tabindex="1" name="categorie" data-parsley-id="1">
                        <% for (TypeObjet c : lsCategorie) { %>
                            <option value="<%= c.getId() %>"><%= c.getVal()%></option>
                        <% } %>
                    </select>
                </div>
            </div>

            <!-- Boutons -->
            <div class="btn-group-container" style="margin-top: 1rem;">
                <button class="btn btn-primary pull-right" style="margin-top : 5px;" name="Submit" type="submit">G&eacute;n&eacute;rer</button>
            </div>
        </div>

        <input name="bute" type="hidden" id="bute" value="paie/editionmoisannee/salaire-saisie.jsp">
        <input name="acte" type="hidden" id="nature" value="genener_paie">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script>
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<%
        return;
    }
%>