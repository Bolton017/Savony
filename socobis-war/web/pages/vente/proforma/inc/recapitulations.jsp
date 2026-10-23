<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.RecetteLib" %>
<%
    try {
        RecetteLib p = new RecetteLib();
        p.setNomTable("AS_RECETTE_LIBCOMPLET"); 
        String id = request.getParameter("idmere");
        RecetteLib[] liste = RecetteLib.getbyProduits(id,null);
        String lien = (String) session.getValue("lien");
        double montantTotal = Double.parseDouble(request.getParameter("vente")) ;
        double qte = Double.parseDouble(request.getParameter("qte")) ;
        double montantRevient = 0.0;
%>

<div class="box-body">
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Composant</th>
                <th>Quantit&eacute;</th>
                <th>Prix Unitaire</th>
                <th>Unit&eacute;</th>
            </tr>
        </thead>

        <tbody id="ingredientsListe">
            <%
                if (liste != null && liste.length > 0) {
                    for (int i = 0; i < liste.length; i++) {
                        montantRevient += liste[i].getQuantite() * qte * liste[i].getPu();
            %>
            <tr id="ingredients-id-<%=i%>" onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                <td>
                    <%=liste[i].getLibelleingredient()%>
                </td>
                <td>
                    <%=liste[i].getQuantite() * qte%>
                </td>
                <td>
                    <%=liste[i].getPu()%>
                </td>
                <td>
                    <%=liste[i].getValunite()%>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="5"><center><h4>Aucune donnée trouvée</h4></center></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%" class="table">
            <tr>
                <td><b>Montant Vente:</b></td>
                <td><%=montantTotal%></td>
            </tr>
            <tr>
                <td><b>Montant Revient:</b></td>
                <td><%=montantRevient%></td>
            </tr>
            <tr>
                <td><b>Marge Brute:</b></td>
                <td><%=montantTotal - montantRevient%></td>
            </tr>
        </table>
    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>