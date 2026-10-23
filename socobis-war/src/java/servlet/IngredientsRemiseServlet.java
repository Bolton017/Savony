package servlet;

import produits.IngredientsRemise;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/IngredientsRemiseServlet")
@MultipartConfig
public class IngredientsRemiseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {

            String idProduit = request.getParameter("idProduit");
            String idClient = request.getParameter("idClient");
            String idPoint = request.getParameter("idPoint");

            IngredientsRemise ingredientRemise =
                    IngredientsRemise.getIngredientRemise(idClient, idPoint, idProduit, null);

            String json;



            if (ingredientRemise.getRemise() == 0) {

                json = "{"
                        + "\"hasRemise\":true,"
                        + "\"remise\":" + ingredientRemise.getRemise() + ","
                        + "\"pvRemise\":" + ingredientRemise.getPvTva()
                        + "}";

            } else {

                double remisePourcentage = ingredientRemise.getRemise();
                double prixNormal = ingredientRemise.getPvTva();
                double montantRemise = prixNormal * remisePourcentage / 100.0;

                json = "{"
                        + "\"hasRemise\":true,"
                        + "\"remise\":" + montantRemise + ","
                        + "\"pvRemise\":" + ingredientRemise.getPvTva()
                        + "}";

            }

            response.getWriter().write(json);

        } catch (Exception e) {

            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(
                    "{\"error\":\"Erreur recherche remise\"}"
            );
        }
    }
}