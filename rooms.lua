--Version-release 1.0
-- Alexander Stamatov, February 2024

    --the rooms are randomly generated and their descriptions are stored in functions to be randomly called
    --the rooms that you have passed are stored in a string or array
    --after a certian number of rooms accumalate in sthe string or array you get out
    --
    --
    --
    Splitoff_Chance_Threshold = 7  -- select 4 to 9


    print("Voice: would you like to play a little game?")
    io.read()
    print("Voice: well, it doesn't matter wether you want to or not.\n\n\nYou find yourself in a yellow mist, seems like you passed out, as your vision clears, you see that you are in a room.")
    print("type next for the next room, or back to go to the last room")

    map = {}
    map ["r-0"] = "This is the room you started in."
    total_splitoff_count = 0
    splitoff_locations_typer = {}
    splitoff_locations_typer[1] = "1"
    splitoff_locations_room_nmbr = {}
    splitoff_locations_room_nmbr[1] = "1"
    typer = "r"  -- a prefix telling us if this room is parth of the oiginal sequence 'r' or a splitoff sequence 's'
    room_num = 0  -- room number
    x = typer .. "-" .. room_num  -- The room key has a format:  
                                  -- r SequenceNumber - RoomNumber
                                  -- or: 
                                  -- s SequenceNumber - RoomNumber


    function splitoff_room(unvisited)
        parents_room_splitoff_count = tonumber(map[x]:sub(2))  -- !!!! This is what was missing. The current splitoff_count is different from the global splitoff_count.
            if unvisited then
                -- We need to create a new starting room 0 of the splitoff sequence
                -- Create the new starting room
                print("++ Splitoff unvisited (creating) ++")
                print(parents_room_splitoff_count)
                splitoff_locations_typer[parents_room_splitoff_count] = typer
                splitoff_locations_room_nmbr[parents_room_splitoff_count] = room_num
                print("++ Storing typer: " .. typer)
                print("++ Storing room number: " .. room_num )
                typer = "s" .. parents_room_splitoff_count
                print("  ++ New typer = " .. typer)
            else
                -- Enter an existing sptlioff sequence
                typer = "s" .. tonumber(map[x]:sub(2)) 
                print("ooo Splitoff revisited ooo")
                print("ooo Entering Existing splitoff sequence. typer = " .. typer)
                print(" x was: ".. x)
            end
            room_num = 0
            x = typer .. "-" .. room_num
            print(x)
            print(" x now becomes: ".. x)
            if unvisited then
                -- Describe room zero of the the new splitoff sequence
                map[x] = "You enter a " .. g[q] .. " room with " .. h[n] .. " inside of it\n"
                print("\nYou went right in this never explored before direction, and " .. map[x])
                print("map[x] = " .. map[x])
            else
                print("\nYou have taken this right-side door before: " .. map[x])
                print("map[x] = " .. map[x])
            end
    end


    while 1 > 0 do 

        d = math.random(0, 10)

        q = math.random(1, 6)
        n = math.random(1, 11)

        g = {"many cornered", "square", "circular", "long", "domed", "big", "tall", "strange"}
        h = {"a pillar", "nothing", "nothing", "nothing", "a tennis ball", "a small couch", "a couch leaning against the wall", "a long legged chair", "a small table", "dust everywhere","a twig"}
        
        choice = io.read()
        

        if string.sub(choice,1,1)  == "n" then  -- "next"
            -- Going to the next room
            room_num = room_num + 1
            x = typer .. "-"  .. room_num
            print("=== Current room:  " .. x .. "  ===")

            if map [x] == nil then
                -- Next room does not exist. 
                -- Create new room 
                local s
                -- Decide if the new next room will be a splitoff
                if d > Splitoff_Chance_Threshold then
                    d = 0
                    -- New room is a splitoff
                    -- Create the new splitoff
                    total_splitoff_count = total_splitoff_count + 1
                    print("incrementing splitoff to " .. total_splitoff_count)
                    map[x] = "S" .. total_splitoff_count -- 
                    print("making map " .. map[x])
                    print("You come to a room with two exits.\nDo you continue on your route or do you go right?\nTo go right type right.")
                        -- Ask the user which way to go in the newly created splitoff
                        choices = io.read()
                        if string.sub(choices,1,1) == "r" then       -- "right"
                            print("Going Right through this new, never explored door")
                            
                            splitoff_room(true) -- create the new splitoff sequence

                        else
                            print("You have decided to stay on the original path")
                        end
                else
                    -- Next room will be a normal room. Create it here.
                    s = "you enter a " .. g[q] .. " room with " .. h[n] .. " inside of it\n"
                    print(s)
                    map[x] = s
                end
            else
                -- Next room already exists
                if map[x]:sub(1,1) == "S" then
                    -- The room we are going to is a splitoff
                    print("You come to a room with two exits.\nDo you continue on your route or do you go right?\nTo go right type right.")
                        -- Ask the user which way to take in this exsiting splitoff
                        print("x = " .. x)
                        print("map[x] = " .. map[x])
                        choices = io.read()
                        if string.sub(choices,1,1) == "r" then  -- "right"
                            print("fff-rrr Going right after entering a Room with two exits.")
                            print("fff-rrr This leads to target sequence: " .. map[x]:sub(2))
                            if map["s" .. map[x]:sub(2) .. "-0"] == nill then 
                                print("This time you turn Right. You walk through this new, never explored door")
                                print("The room with key " .. "s" .. map[x]:sub(2) .. "-0" .. "  does not yet exist. Will create it...")
                                splitoff_room(true) -- Splitoff room does not exist, create it.
                            else
                                print("The room with key " .. "s" .. map[x]:sub(2) .. "-0" .. "  already exists. Entering splitoff sequence...")
                                print("Turning Right. You decide to visit this side door again.")
                                splitoff_room(false)  -- splitoff sequence already exists
                            end
                        else
                            print("You have decided to stay on the original path")
                        end
                else
                    -- The next room is not a splitoff
                    print(map [x])
                end
            end

        elseif string.sub(choice,1,1) == "b" then  -- choice == "back"
            -- Going back
            second_part = false
            x = typer .. "-" ..  room_num
            if map [x] == "This is the room you started in." then
                print("you cannot go through the wall opposite the door.")

            elseif string.sub(typer, 1, 1) == "s" and room_num == 0 then
                -- We are at the start of the splitoff sequence. 
                -- Need to jump back to source splitoff room in the parent sequence.
                room_num = splitoff_locations_room_nmbr[tonumber(typer:sub(2))]
                print("::Going back to room number :::" .. room_num )
                typer = splitoff_locations_typer[tonumber(typer:sub(2))]
                print("::Going back to typer :::" .. typer )
                print(typer .. "-" .. room_num)
                -- Let the user know that we moved back to the source splitoff.
                print("You came back to a room with two doors.\n")
                x = typer .. "-" .. room_num
            else
                -- still going back along the sequence
                second_part = true
            end
            if second_part == true then
                -- Moving back along the sequence
                room_num = room_num - 1
                x = typer .. "-" .. room_num
                if map[x]:sub(1,1) == "S" then
                    -- Reached a splitoff while going back along the sequence
                    print("You come to a room with two exits.\nDo you continue on your route or do you go right?\nTo go right type right.")
                    print("x = " .. x)
                    print("map[x] = " .. map[x])
                        choices = io.read()
                        if string.sub(choices,1,1) == "r" then       -- "right"
                            -- Enter a Splitoff to the right
                            print("bbb-rrr Going right after reversing into a Room with two exits.")
                            print("bbb-rrr This leads to target sequence: " .. map[x]:sub(2))
                            if map["s" .. map[x]:sub(2) .. "-0"] == nill then
                                print("bbb-rrr Going right into Unexplored sequence.")
                                splitoff_room(true) -- Splitoff room does not exist, create it.
                            else
                                print("bbb-rrr Going right into Existing sequence.")
                                splitoff_room(false) -- splitoff sequence already exists
                            end
                        else
                            print("You have decided to stay on the original path")
                        end
                else
                        print("Going back to a normal room ````")
                        print(x)
                        print(map [x])
                end
            end
        else
            local q = math.random(0, 4)
            if q > 3.7 then
                print("The room seems to creak, as if impatient.\n")
            else
                print("You decide to stay here a while longer.\n")
            end
        end
    end