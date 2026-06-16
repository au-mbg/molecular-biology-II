local path = pandoc.path
local stringify = pandoc.utils.stringify

local function encode_base64(data)
  local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  return ((data:gsub(".", function(byte)
    local bits = ""
    local value = byte:byte()
    for bit = 8, 1, -1 do
      bits = bits .. ((value % 2 ^ bit - value % 2 ^ (bit - 1) > 0) and "1" or "0")
    end
    return bits
  end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(chunk)
    if #chunk < 6 then
      return ""
    end
    local value = 0
    for bit = 1, 6 do
      if chunk:sub(bit, bit) == "1" then
        value = value + 2 ^ (6 - bit)
      end
    end
    return chars:sub(value + 1, value + 1)
  end) .. ({ "", "==", "=" })[#data % 3 + 1])
end

local function mime_type_for(src)
  local _, extension = path.split_extension(src)
  if extension then
    extension = extension:lower()
  end

  local mime_types = {
    [".png"] = "image/png",
    [".jpg"] = "image/jpeg",
    [".jpeg"] = "image/jpeg",
    [".gif"] = "image/gif",
    [".svg"] = "image/svg+xml",
    [".webp"] = "image/webp",
  }

  return mime_types[extension]
end

local function read_file_binary(file_path)
  local handle = io.open(file_path, "rb")
  if not handle then
    return nil
  end

  local contents = handle:read("*all")
  handle:close()
  return contents
end

local function escape_html_text(text)
  return text
    :gsub("&", "&amp;")
    :gsub("<", "&lt;")
    :gsub(">", "&gt;")
    :gsub('"', "&quot;")
end

local function serialize_image_attributes(image)
  local parts = {}
  local fig_align = image.attributes["fig-align"]
  local style = image.attributes["style"]

  if image.identifier ~= "" then
    table.insert(parts, string.format(' id="%s"', escape_html_text(image.identifier)))
  end

  if #image.classes > 0 then
    table.insert(parts, string.format(' class="%s"', escape_html_text(table.concat(image.classes, " "))))
  end

  for key, value in pairs(image.attributes) do
    if key ~= "fig-align" and key ~= "style" then
      table.insert(parts, string.format(' %s="%s"', key, escape_html_text(value)))
    end
  end

  if fig_align == "center" then
    style = style and (style .. "; display: block; margin-left: auto; margin-right: auto")
      or "display: block; margin-left: auto; margin-right: auto"
  end

  if style and style ~= "" then
    table.insert(parts, string.format(' style="%s"', escape_html_text(style)))
  end

  return table.concat(parts)
end

local function resolve_image_path(src)
  if src:match("^[a-z]+:") or src:match("^data:") then
    return nil
  end

  if path.is_absolute(src) then
    return src
  end

  local input_file = PANDOC_STATE.input_files[1]
  if input_file then
    local input_dir = path.directory(input_file)
    local candidate = path.normalize(path.join({ input_dir, src }))
    local handle = io.open(candidate, "rb")
    if handle then
      handle:close()
      return candidate
    end
  end

  return path.normalize(src)
end

function Image(image)
  if not FORMAT:match("ipynb") and not FORMAT:match("jupyter") then
    return nil
  end

  local mime_type = mime_type_for(image.src)
  if not mime_type then
    return nil
  end

  local file_path = resolve_image_path(image.src)
  if not file_path then
    return nil
  end

  local contents = read_file_binary(file_path)
  if not contents then
    return nil
  end

  local data_uri = "data:" .. mime_type .. ";base64," .. encode_base64(contents)
  local alt = escape_html_text(stringify(image.caption))
  local title = image.title ~= "" and string.format(' title="%s"', escape_html_text(image.title)) or ""
  local attributes = serialize_image_attributes(image)

  -- Emit raw HTML so the ipynb writer preserves the inline data URI
  -- instead of rewriting the image into a notebook attachment.
  return pandoc.RawInline(
    "html",
    string.format('<img src="%s" alt="%s"%s%s />', data_uri, alt, title, attributes)
  )
end
