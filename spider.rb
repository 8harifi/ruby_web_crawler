# require 'net/http'
require 'open-uri'
require 'nokogiri'

def is_valid(url)
    if url.start_with?("http://") or url.start_with?("https://")
        return true
    else
        return false
    end
end

print "url> "
url = gets().chomp

if not is_valid(url)
    puts "[!] ERROR: Invalid URL"
    exit
end

# begin
#     uri = URI(url)
# rescue
#     puts "Invalid URL"
# end

que = [url]
for url in que
    html = open(url)
    doc = Nokogiri::HTML(html)
    tags = doc.css("a")
    for tag in tags
        link = tag.attributes['href'].text
        if link != nil
            if link.start_with?("/")
                que.push(link)
                puts "[+] Found: #{link}"
            else
                if url.end_with?("/")
                    que.push(url+link)
                    puts "[+] Found: #{url[0..-2]+link}"
                else
                    que.push(url+link)
                    puts "[+] Found: #{url+link}"
                end
            end
        end
    end
    que.delete(url)
end
