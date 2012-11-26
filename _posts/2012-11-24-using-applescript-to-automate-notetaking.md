---
layout: post
title: Using AppleScript to Automate Notetaking
date: 2012-11-24 09:19:18
tags:
- productivity
---
On [a recent episode](http://www.70decibels.com/generational/2012/11/10/009-research-materials-and-tools-with-walton-jones.html) of [Gabe Weatherhead's](http://www.macdrifter.com) Generational podcast he spoke with [Walton Jones](http://drosophiliac.com), professor of Behavioral Neurobiology at Korea Advanced Institute of Science and Technology. They talk about Professor Jones' system for annotating and summarizing academic papers about twenty minutes into the podcast. He's further detailed his [academic workflow on his blog](http://drosophiliac.com/2012/09/an-academic-notetaking-workflow.html), so be sure to give his explanation a read.

I've noted before how I [manage my PDFs using the filesystem](http://www.jasonheppler.org/2012/08/13/towards-better-pdf-management-with-the-filesystem.html) and Open Meta tagging. I've tended to maintain my notes in plain text written directly into DEVONthink, but after listening to Weatherhead's talk with Jones and reading his post I've decided to adopt part of his system. 

As a scientist Jones spends much of his time synthesizing the latest research that normally comes to him as a PDF from journals. Where I became interested in his system was 1) his color coded annotations and 2) his method of extracting those annotations to plain text. His system uses colors for different notes, green for references, red for summaries, and so on. Where the system really inspired me was his AppleScript that can process the PDF he has marked up (either in [Skim]() or [iAnnotate]()) that scans the PDF and extracts notes based on his categorization using Markdown syntax. He then dumps the notes into Voodoo Pad. Be sure to [read his explanation](http://drosophiliac.com/2012/09/an-academic-notetaking-workflow.html) of his system as my summary doesn't do it complete justice.

The system relies on an AppleScript that looks for annotations in the PDF and extracts the text into Markdown-formatted plain text. I modified the script slightly for my own needs:

{% highlight applescript %}
tell application "Skim"
    set the clipboard to ""
    set numberOfPages to count pages of document 1
    
    activate
    set myColorCodes to my chooseColor()
    
    set firstPage to "1" as number
    set lastPage to numberOfPages
    set the clipboard to "# Notes #" & return & return
    
    repeat with currentPage from firstPage to lastPage
        set pageNotes to notes of page currentPage of document 1
        exportPageNotes(pageNotes, currentPage, myColorCodes) of me
    end repeat
    
end tell

on exportPageNotes(listOfNotes, pageForProcessing, myColorCodes)
    tell application "Skim"
        
        set currentPDFpage to pageForProcessing
        repeat with coloredNote in listOfNotes
            
            repeat with i from 1 to the count of myColorCodes
                if color of coloredNote is item i of myColorCodes then
                    set categoryColors to ({"Summary", "Methods", "Arguments", "Reference", "Thesis", "Question or connection"})
                    set noteColor to color of coloredNote as string
                    if noteColor is item i of myColorCodes as string then
                        set noteColor to item i of categoryColors
                    end if
                    set noteText to get text for coloredNote
                    set the clipboard to (the clipboard) & "**[" & noteColor & "]" & "(" & name of document 1 & "#page=" & pageForProcessing & ")**" & ":   " & return & noteText & return & return
                end if
            end repeat
        end repeat
        
    end tell
end exportPageNotes

on chooseColor()
    set selectedColors to ({"Summary", "Methods", "Arguments", "Reference", "Thesis", "Question or connection"})
    set colorCodes to {}
    set noteColor to ""
    repeat with noteCol in selectedColors
        set noteColor to noteCol as text
        if noteColor is "Summary" then
            set end of colorCodes to {64634, 900, 1905, 65535}
        else if noteColor is "Methods" then
            set end of colorCodes to {64907, 32785, 2154, 65535}
        else if noteColor is "Arguments" then
            set end of colorCodes to {65535, 65531, 2689, 65535}
        else if noteColor is "Reference" then
            set end of colorCodes to {8608, 65514, 1753, 65535}
        else if noteColor is "Thesis" then
            set end of colorCodes to {8372, 65519, 65472, 65535}
        else if noteColor is "Question or connection" then
            set end of colorCodes to {64587, 1044, 65481, 65535}
            
        end if
    end repeat
    
    return colorCodes
end chooseColor
{% endhighlight %}

I take my notes in Skim, which would result in something like:

![Skim notes](http://farm9.staticflickr.com/8339/8205161519_f4b08fcbe4.jpg "Skim notes")

When the script is run on a PDF, it results in a note formatted in Markdown that looks similar to this:

{% highlight console %}
# Notes #

**[Reference](file://example.pdf#page=3**:
Reference text would appear here extracted automatically from the PDF.
{% endhighlight %}

That's where the other half of the magic comes in Jones's system. The note not only includes the text I wanted but also a hyperlink to the page of a particular reference. Transformed into Markdown, the note allows me to click on the reference and be taken back to the source. My notes use to appear similarly, often taking a form such as:

{% highlight console %}
[3] Noting the page number in brackets followed by my notes, thoughts, direct quotes, and so on from a PDF or book.
{% endhighlight %}

As I mentioned, my notes were previously entered directly into DEVONthink. But with this new system I'll be keeping my notes in the same directory as the document I'm taking notes on. From there, DEVONthink will index the directory for easy searching and organizing.