import java.sql.SQLException;

public class Main {
    public static void main(String[] args) {
        // Log before changes
        DBConnection dbConnection = new DBConnection();
        DataRetriever retriever = new DataRetriever();

        // Test plat id = 1 (Salade fraîche)
        System.out.println("\nPlat id = 1 (Salade fraîche)");
        try {
            Dish saladeFraiche = retriever.findDishById(1);
            if (saladeFraiche == null) {
                System.out.println("Plat non trouvé");
            } else {
                System.out.println("Nom : " + saladeFraiche.getName());
                System.out.println("Type : " + saladeFraiche.getDishType());
                System.out.println("Prix total : " + saladeFraiche.getDishCost());
                System.out.println("Ingrédients :");
                for (Ingredient ing : saladeFraiche.getIngredients()) {
                    System.out.println(" - " + ing.getName() + " (" + ing.getPrice() + ")");
                }
            }
        } catch (SQLException e) {
            System.out.println("Erreur : " + e.getMessage());
        }


        // Log after changes
        //
        //dish.setIngredients(List.of(new Ingredient(1), new Ingredient(2)));
        //Dish newDish = dataRetriever.saveDish(dish);
        //System.out.println(newDish);

        // Ingredient creations
        //List<Ingredient> createdIngredients = dataRetriever.createIngredients(List.of(new Ingredient(null, "Fromage", CategoryEnum.DAIRY, 1200.0)));
        //System.out.println(createdIngredients);
    }
}