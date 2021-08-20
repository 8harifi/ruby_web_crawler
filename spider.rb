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

print "time_out> "
time_out = gets().chomp

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
    begin
        html = URI.open(url, :read_timeout => time_out.to_i)
    rescue Exception => Interrupt
        puts "Canceled by user"
        exit
    rescue Exception => OpenURI::HTTPError
        puts "[-] Couldn't open: #{url}"
    end
    doc = Nokogiri::HTML(html)
    tags = doc.css("a")
    for tag in tags
        begin
            link = tag.attributes['href'].text
            if not link.start_with?("/")
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
        rescue Exception => NoMethodError
            # Do nothin
        rescue Exception => Interrupt
            puts "Canceled by user"
        end
    end
    que.delete(url)
end
