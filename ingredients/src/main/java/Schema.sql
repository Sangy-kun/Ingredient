CREATE USER mini_dish_db_manager WITH PASSWORD '123456';

CREATE DATABASE mini_dish_db;

\c mini_dish_db;

GRANT ALL PRIVILEGES ON DATABASE mini_dish_db TO mini_dish_db_manager;

--creation des enums

CREATE TYPE dish_type_enum AS ENUM ('START', 'MAIN', 'DESSERT');
CREATE TYPE category_enum AS ENUM ('VEGETABLE', 'ANIMAL', 'MARINE', 'DAIRY', 'OTHER');

CREATE TABLE dish (
                      id SERIAL PRIMARY KEY,
                      name VARCHAR(255) NOT NULL,
                      dish_type dish_type_enum NOT NULL
);

CREATE TABLE ingredient (
                              id SERIAL PRIMARY KEY,
                              name VARCHAR(255) NOT NULL,
                              price NUMERIC(10,2) NOT NULL,
                              category category_enum NOT NULL,
                              id_dish INT,
                              CONSTRAINT fk_dish FOREIGN KEY (id_dish) REFERENCES dish(id)
  );


INSERT INTO dish (id, name, dish_type) VALUES
                                           (1, 'Salade fraîche', 'START'),
                                           (2, 'Poulet grillé', 'MAIN'),
                                           (3, 'Riz aux légumes', 'MAIN'),
                                           (4, 'Gâteau au chocolat', 'DESSERT'),
                                           (5, 'Salade de fruits', 'DESSERT');



INSERT INTO ingredient (id, name, price, category, id_dish) VALUES
                                                                (1, 'Laitue', 800.00, 'VEGETABLE', 1),
                                                                (2, 'Tomate', 600.00, 'VEGETABLE', 1),
                                                                (3, 'Poulet', 4500.00, 'ANIMAL', 2),
                                                                (4, 'Chocolat', 3000.00, 'OTHER', 4),
                                                                (5, 'Beurre', 2500.00, 'DAIRY', 4);


--Suite sujet donc nouveau sql (je ne sais pas si je dois mettre à jour l'ancien ou non donc je vais
--directement reecrire un nouveau
--mais avant il faut faire des drop table car c'est ultra compliqué de faire des alter chaque fois ici

-- Table Ingredient (ingrédients uniques)

DROP TABLE ingredient;

CREATE TABLE dish_ingredient (
                                 dish_id INT NOT NULL,
                                 ingredient_id INT NOT NULL,
                                 PRIMARY KEY (dish_id, ingredient_id),  -- pas de doublons
                                 FOREIGN KEY (dish_id) REFERENCES dish(id) ON DELETE CASCADE,
                                 FOREIGN KEY (ingredient_id) REFERENCES ingredient(id) ON DELETE CASCADE
);



/*ON DELETE CASCADE : c'est comme si je supprimais un plat du menu donc je supprime aussi le lien dans la table
  de jonction afin que la base reste propre
  C'est une contrainte sql pour les clés etrangère
 */



CREATE TYPE unit_enum AS ENUM ('PCS', 'KG', 'L');

-- Table Ingredient (ingrédients uniques, pas de id_dish)
CREATE TABLE ingredient (
                            id SERIAL PRIMARY KEY,
                            name VARCHAR(255) NOT NULL UNIQUE,
                            price NUMERIC(10,2) NOT NULL,
                            category category_enum NOT NULL
);



CREATE TABLE dish (
                      id SERIAL PRIMARY KEY,
                      name VARCHAR(255) NOT NULL,
                      dish_type dish_type_enum NOT NULL,
                      price NUMERIC(10,2)
);


CREATE TABLE dish_ingredient (
                                 id SERIAL PRIMARY KEY,
                                 id_dish INTEGER NOT NULL REFERENCES dish(id) ON DELETE CASCADE,
                                 id_ingredient INTEGER NOT NULL REFERENCES ingredient(id) ON DELETE CASCADE,
                                 quantity_required NUMERIC(10,2) NOT NULL,
                                 unit unit_enum NOT NULL,
                                 UNIQUE (id_dish, id_ingredient)  -- un ingrédient par plat une seule fois
);

INSERT INTO ingredient (name, price, category) VALUES
                                                     ('Laitue', 800.00, 'VEGETABLE'),
                                                     ('Tomate', 600.00, 'VEGETABLE'),
                                                     ('Poulet', 4500.00, 'ANIMAL'),
                                                     ('Chocolat', 3000.00, 'OTHER'),
                                                     ('Beurre', 2500.00, 'DAIRY')
  ON CONFLICT (name) DO NOTHING;


INSERT INTO dish (name, dish_type, price) VALUES
                                              ('Salade fraîche', 'START', 3500.00),
                                              ('Poulet grillé', 'MAIN', 12000.00),
                                              ('Riz aux legumes', 'MAIN', NULL),
                                              ('Gateau au choco', 'DESSERT', 8000),
                                              ('Salade de fruit', 'DESSERT', NULL);


INSERT INTO dish_ingredient (id_dish, id_ingredient, quantity_required, unit) VALUES
                                                                                  (1, 1, 0.20, 'KG'),
                                                                                  (1, 2, 0.15, 'KG'),
                                                                                  (2, 3, 1.00, 'KG'),
                                                                                  (4, 4, 0.30, 'KG'),
                                                                                  (4, 5, 0.20,'KG')
ON CONFLICT DO NOTHING;