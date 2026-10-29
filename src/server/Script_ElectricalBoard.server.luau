local Workspace = game:GetService("Workspace")
local Elevator = Workspace:WaitForChild("Elevator")
local Exterior = Elevator:WaitForChild("Exterior")
local Tube = Exterior:WaitForChild("Tube")
local FrontWall = Tube:WaitForChild("FrontWall")
local Electrical = FrontWall:WaitForChild("ElectricalBoard")
local LightAlert = Electrical:WaitForChild("LightAlert")

-- Voyant Rouge déclaration
local VoyantRed = LightAlert:WaitForChild("VoyantRed")
local VoyantRouge = VoyantRed:WaitForChild("Voyant")
local Redlight = VoyantRouge:WaitForChild("SurfaceLight")

-- Voyant Orange déclaration
local VoyantOrange = LightAlert:WaitForChild("VoyantOrange")
local VoyantOrang = VoyantOrange:WaitForChild("Voyant")
local Orangelight = VoyantOrang:WaitForChild("SurfaceLight")

-- Voyant Vert déclaration
local VoyantGreen = LightAlert:WaitForChild("VoyantGreen")
local VoyantVert = VoyantGreen:WaitForChild("Voyant")
local Greenlight = VoyantVert:WaitForChild("SurfaceLight")

-- fonction clignottement
local function Clignottement()
    -- Boucle pour Voyant rouge (clignottement continue)
    task.spawn(function()
        while true do 
            -- Allumage de la surfacelight et matérial en neon 
            Redlight.Enabled=true
            VoyantRouge.Material=Enum.Material.Neon
            -- Petit temps d'attente pour faire clignottement
            task.wait(0.8)
            -- Eteindre la surfacelight et matérial en smooth plastic
            Redlight.Enabled=false
            VoyantRouge.Material=Enum.Material.SmoothPlastic
            task.wait(0.8)
        end
    end)

    -- Boucle pour Voyant orange (éteint continue clignottement toutes les 4 secondes)
    task.spawn(function()
        while true do 
            -- Eteind de la surfacelight et matérial en smooth plastic 
            Orangelight.Enabled=false
            VoyantOrang.Material=Enum.Material.SmoothPlastic
            -- Petit temps d'attente pour attendre clignottement
            task.wait(4)
            -- alumer la surfacelight et matérial en neon
            Orangelight.Enabled=true
            VoyantOrang.Material=Enum.Material.Neon
            -- temps de l'allumage
            task.wait(0.7)
        end
    end)

        -- Boucle pour Voyant vert (allumé continue clignottement toutes les 2 secondes)
    task.spawn(function()
        while true do 
            -- alumer la surfacelight et matérial en neon
            Greenlight.Enabled=true
            VoyantVert.Material=Enum.Material.Neon
            -- Petit temps d'attente pour attendre clignottement
            task.wait(4)
            -- boucle de deux séquences pour faire clignoter deux fois de suite
            for i = 1,2,1 do 
                -- alumer la surfacelight et matérial en neon
                Greenlight.Enabled=false
                VoyantVert.Material=Enum.Material.SmoothPlastic
                -- temps de l'allumage
                task.wait(0.25)
                Greenlight.Enabled=true
                VoyantVert.Material=Enum.Material.Neon
                task.wait(0.25)
            end
        end
    end)
end

Clignottement()