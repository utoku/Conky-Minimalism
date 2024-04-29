require 'cairo'


--debug function
function conky_main2()
   if conky_window == nil then return end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable,
    conky_window.visual, conky_window.width, conky_window.height)

    -- Initialize cairo context
    cr = cairo_create(cs)

    draw_number()

    cairo_destroy(cr)
end   

-- Function to draw GMT clock
function conky_main()
    if conky_window == nil then return end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable,
    conky_window.visual, conky_window.width, conky_window.height)

    -- Initialize cairo context
    cr = cairo_create(cs)

    -- Custom settings for your clock
    local clock_radius = 100  -- radius of clock
    local clock_x = 150       -- x position of clock center
    local clock_y = 400       -- y position of clock center
    local clock_color = {1, 1, 1, 1}  -- color of clock in RGBA format




    -- Create GMT bezel
    local bezel_radius = clock_radius + 20 -- or whatever distance you want the bezel to be at
    local bezel_thickness = 20 -- or your desired thickness
    local bezel_color_am = {1, 0, 0, 1} -- red color for AM
    local bezel_color_pm = {0, 0, 1, 1} -- blue color for PM
    
    -- Draw GMT bezel
    draw_bezel(clock_x, clock_y, bezel_radius, bezel_thickness, bezel_color_am, bezel_color_pm)
    -- Draw 24 hour numbers on bezel
    local number_distance = clock_radius + 15 -- adjust accordingly
    local number_color = {1, 1, 1, 1} -- white color for the numbers
    --draw_bezel_numbers(clock_x, clock_y, number_distance, number_color)
    --draw_number_old(clock_x, clock_y+50)
    
    -- Custom settings for your hour pips
    local pips_radius = 8  -- radius of hour pips
    local pips_color = {1, 1, 1, 1}  -- color of hour pips in RGBA format
    local pips_distance = clock_radius + 10  -- distance from center of clock

    
    -- Draw hour pips
    for hours = 1,12 do
       local angle = (hours%12)/12 * 2 * math.pi
       draw_pip(clock_x, clock_y, angle, pips_distance, pips_radius, pips_color)
    end


    local second_hand_length = 0.9 * clock_radius  -- length of second's hand
    local minute_hand_length = 0.7 * clock_radius  -- length of minute's hand
    local hour_hand_length = 0.5 * clock_radius    -- length of hour's hand

    -- Get GMT time
    local seconds=os.date("%S")
    local minutes=os.date("%M")
    local hours=os.date("%I")

    
    -- Draw clock hands
    draw_hand(clock_x, clock_y, seconds/60 * 2 * math.pi, second_hand_length, clock_color)
    draw_hand(clock_x, clock_y, minutes/60 * 2 * math.pi, minute_hand_length, clock_color)
    draw_hand(clock_x, clock_y, (hours%12)/12 * 2 * math.pi, hour_hand_length, clock_color)


    
    -- Release resources
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr = nil
end

-- Function to draw clock hands
function draw_hand(center_x, center_y, angle, hand_length, color)
    local hand_end_x = center_x + hand_length * math.sin(angle)
    local hand_end_y = center_y - hand_length * math.cos(angle)

    cairo_set_line_width(cr, 3)
    
    cairo_set_source_rgba(cr, color[1], color[2], color[3], color[4])
    cairo_move_to(cr, center_x, center_y)
    cairo_line_to(cr, hand_end_x, hand_end_y)
    cairo_stroke(cr)
end

-- Function to draw hour pips
function draw_pip(center_x, center_y, angle, distance, radius, color)
    local pip_x = center_x + distance * math.sin(angle)
    local pip_y = center_y - distance * math.cos(angle)

    cairo_set_source_rgba(cr, color[1], color[2], color[3], color[4])
    cairo_arc(cr, pip_x, pip_y, radius, 0, 2*math.pi)
    cairo_fill(cr)
end


-- Function to draw GMT bezel
function draw_bezel(center_x, center_y, radius, thickness, am_color, pm_color)
    -- Draw AM part of bezel
    cairo_set_source_rgba(cr, am_color[1], am_color[2], am_color[3], am_color[4])
    cairo_set_line_width(cr, thickness)
    cairo_arc(cr, center_x, center_y, radius, 0, math.pi)
    cairo_stroke(cr)

    -- Draw PM part of bezel
    cairo_set_source_rgba(cr, pm_color[1], pm_color[2], pm_color[3], pm_color[4])
    cairo_arc(cr, center_x, center_y, radius, math.pi, 2*math.pi)
    cairo_stroke(cr)
end


-- Function to draw 24h numbers on bezel
function draw_bezel_numbers(center_x, center_y, distance, color)
   cairo_select_font_face(cr, "Ubuntu Mono:size=10", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size(cr, 10) -- Set this to your desired font size
    cairo_set_source_rgba(cr, color[1], color[2], color[3], color[4])

    for hour = 1,24 do
        local angle = (hour % 24) / 24 * 2 * math.pi
        local number_x = center_x + distance * math.sin(angle)
        local number_y = center_y - distance * math.cos(angle)
        local number_text = tostring(hour)

        -- Calculate text position to ensure it's centered
        local text_x_bearing, text_y_bearing, text_width, text_height = cairo_text_extents(cr, number_text)
        number_x = number_x - text_width / 2
        number_y = number_y - text_height / 2

        -- Draw hour number
        cairo_move_to(cr, number_x, number_y)
        cairo_show_text(cr, number_text)
    end
end

--debug functions 
function draw_number_old(center_x, center_y)
   cairo_select_font_face(cr, "'Ubuntu Mono:size=10'", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
   cairo_set_font_size(cr,20)
   cairo_set_source_rgba(cr, 0, 1, 0, 0)

   cairo_move_to(cr, center_x, center_y)
   cairo_show_text(cr, "Hede")
end 

function draw_number()
    cairo_select_font_face(cr, "'Ubuntu Mono:size=10'", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size(cr, 20) 
    cairo_set_source_rgba(cr, 1, 0, 0, 1) -- red color, fully opaque
   
    -- local x = conky_window.width / 2
    -- local y = conky_window.height / 2 

    cairo_move_to(cr, 10, 10)
    cairo_show_text(cr, "Hede")
end
