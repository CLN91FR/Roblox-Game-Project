
local Workspace = game:GetService("Workspace")
local Elevator = Workspace:WaitForChild("Elevator") -- récupération du modèle ascenseur
local Compt = Elevator:WaitForChild("Compteur_elevator2") -- récupération du modèle compteur
local Light = Compt:WaitForChild("BoardLight") -- récupération ensemble lumières model
local Demande = Compt:WaitForChild("Demande") -- le Bindable Event qui seras le signal envoyé pour utiliser notre compteur

local board ={} --tableau des ampoules réeles

local lignes=12  --variable lignes
local colonnes=8 --variable colonnes

local OrigineColor = Light:WaitForChild("1_1").Color
local OrigineMaterial = Light:WaitForChild("1_1").Material


----------------------------------------------------------------------------------
------------------- !!! TABLEAU DES SYMBOLES !!! ---------------------------------
----------------------------------------------------------------------------------



local Draw_arrowUP =
{{0,0,0,0,0,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,1,1,1,1,0,0},
 {0,1,1,1,1,1,1,0},
 {1,1,1,1,1,1,1,1},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,0,0,0,0,0}}


 local Draw_arrowDOWN =
{{0,0,0,0,0,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {1,1,1,1,1,1,1,1},
 {0,1,1,1,1,1,1,0},
 {0,0,1,1,1,1,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,0,0,0,0,0}}


local Draw_STAR1 =
{{0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0}}


local Draw_STAR2 =
{{0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,1,1,1,1,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,1,0,0,1,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0}}


local Draw_STAR3 =
{{0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,1,1,1,1,1,1,0},
 {0,0,1,1,1,1,0,0},
 {0,0,1,1,1,1,0,0},
 {0,1,1,0,0,1,1,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0}}


 local Draw_STAR4 =
{{0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,1,1,1,1,0,0},
 {1,1,1,1,1,1,1,1},
 {0,1,1,1,1,1,1,0},
 {0,0,1,1,1,1,0,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,0}}


local Draw_0 =
{{0,0,0,0,0,0,0,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,0,0,0,0,0,0,0}}


local Draw_1 =
{{0,0,0,0,0,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,1,1,1,0,0,0},
 {0,1,1,1,1,0,0,0},
 {1,1,1,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,0,0,0,0,0,0,0}}

local Draw_2 =
{{0,0,0,0,0,0,0,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,0,0,0,0,1,1,0},
 {0,0,0,0,0,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,0,0,0,0,0},
 {0,1,1,0,0,0,0,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,0,0,0,0,0,0,0}}




-- Dictionnaire contenant l'ensemble des draw de symbole possible
local draw = {
	["Draw_arrowUP"] = Draw_arrowUP,
	["Draw_arrowDOWN"] = Draw_arrowDOWN,
	["Draw_STAR1"] = Draw_STAR1,
	["Draw_STAR2"] = Draw_STAR2,
	["Draw_STAR3"] = Draw_STAR3,
	["Draw_STAR4"] = Draw_STAR4,
	["Draw_0"] = Draw_0,
	["Draw_1"] = Draw_1,
	["Draw_2"] = Draw_2
}


------------------- FONCTIONS ---------------------------


local function creer_matrice(lignes, colonnes, valeur)

	local new_matrice = {}  -- Matrice de départ

	-- boucle pour faire à chaque lignes une liste de "colonnes" colonnes avec comme valeur "valeur"
	for i=1, lignes do
		new_matrice[i] = table.create(colonnes, valeur) -- création d'un liste de "colonnes" éléments de valeur "valeur"
	end

	return new_matrice
end


--fonction pour reset affichage du board
local function reset_table()

-- renitialisation du tableau d'ampoules pour avoir un tableau éteint
	for i=1, lignes do
		for j=1, colonnes do
			board[i][j].Material=OrigineMaterial  -- matérieaux d'origine
			board[i][j].Color=OrigineColor  -- couleur d'origine
		end
	end 
	print("reset du compteur pour afficher") 

end


-- function pour renvoyer la même table mais dont chaque ligne est décaler de "décalage"
local function decal_ligne (table, decalage) 

	--création d'un matrice de même taille que "table"
	local new_table = creer_matrice(#table, #table[1]) 

	-- boucle qui met la ligne[i] de la table d'origine à sa nouvelle position après décalage dans la nouvelle table
	for i=1, #table do
		-- la nouvelle position correspond aux reste de la divisions de la lignes actuelle + décalage par le nombre total de lignes de la matrice original
		new_table[((i-1+decalage)% #table )+1] = table[i] 
	end

	return new_table

end	

-- Création du tableau contenant chaque light sous la forme d'un matrice 12*8
for i=1,lignes do
	board[i]={} -- on ajoute le tableau de la ligne i
	for j=1,colonnes do
		local nom_ampoule = i.."_"..j
		board[i][j]=Light:WaitForChild(nom_ampoule)
	end
	
end

-- fonction pour afficher la symbole "table_symbole" de couleur "color" et qui fera une animation de décalage "decalage" (0 si pas d'animation voulu)
local function Affichage_symbole(table_symbole, color)

	-- reset du board
	reset_table()
	-- application du symbole sur le board en parcourant le Draw

	-- On va parcourir le Draw ligne par ligne pour le reproduire sur le board
	for i=1, lignes do
		for j=1, colonnes do
			if table_symbole[i][j]==1 then -- si c'est bien une case qu'on souhaite colorer car marquer d'un "1" sur le draw alors on met en rouge et néon
				board[i][j].Material=Enum.Material.Neon
				board[i][j].Color = color -- la couleur demandé en argument
			end
		end
	end 

end


-- fonction pour l'animation étoile
local function AnimationEtoile(color)
	--intialisation de la variable qui nous indiquera quel matrice voulu à chaque tour de la boucle
	local nom_Draw = nil
	local table_demande = nil

	-- tant que l'ascenseur est en mode disco (son attribute nous l'indique) alors on continue l'animation étoile
	while Elevator:GetAttribute("disco") == true do
		-- boucle de 1 à 4 nous permettant de faire apparaître Draw_STAR de 1 à 4 afin de faire une animation
		for i=1, 5 do
			-- si i = 5 (dernier état de l'animation) alors on remet l'écran à zero (tout vide)
			if i==5 then
				reset_table()
				-- on ne suit pas le code or du if car fin d'une séquence d'animation
				task.wait(0.1) -- petite attente pour effet d'animation pas trop rapide
				continue
			end
			-- nous permet de d'obtenir Draw_STAR1 puis DRAW_STAR2 etc... à chaque nouvelle itération
			nom_Draw = "Draw_STAR"..tostring(i)
			table_demande = draw[nom_Draw]
			Affichage_symbole(table_demande, color)
			task.wait(0.1) -- petite attente pour effet d'animation pas trop rapide
			if i==4 then
			task.wait(0.1) -- petite attente supplémentaire pour montrer plus longtemps l'étoile final
			end
		end
	end
end


local function AllumerSymbole(symbole, color, decalage)
	
	-- si on demande l'étoile alors faire l'animation spécifique
	if symbole == "STAR" then
		AnimationEtoile(color)
		-- pour sortir de la fonction sans faire le reste du code de cette fonction
		return
	end

	-- recherche de la matrice du symbole demander
	local nom_Draw="Draw_"..tostring(symbole)
	local Table_demander = draw[nom_Draw]  -- on initialise la variable qui va nous permettre de savoir quelles matrice utiliser

	-- si le décalage n'est pas nul on doit faire une animation
	if decalage ~= 0 then
		while Elevator:GetAttribute("Mooving") == true do  -- tant que l'ascenseur n'est pas arrivé on continue la boucle while d'animation
			Affichage_symbole(Table_demander, color)
			Table_demander = decal_ligne(Table_demander, decalage) -- on applique le decalage
			task.wait(0.1) -- petite attente avant d'afficher prochaine matrice decaler
		end
		reset_table() -- remettre l'affichage à vide car plus de mouvement
		return --mettre fin à la fonction après que l'ascenseur soit arriver
	end	
	-- on utiliser la fonction qui va afficher la matrice Table_demander avec sa couleur
	Affichage_symbole(Table_demander, color)
end

Demande.Event:Connect(AllumerSymbole) -- On connecte le bindable events pour qu'il déclent la fonction de dessin de symbole lorsqu'il recoit le signal
