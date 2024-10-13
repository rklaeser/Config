#!/bin/bash

# Function to get Spotify status and track info
get_spotify_info() {
    STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)
    
    if [ "$STATE" = "playing" ]; then
        MEDIA=$(osascript -e 'tell application "Spotify" to get the name of the current track & " - " & the artist of the current track')
        echo "$MEDIA"
    else
        echo ""
    fi
}

# Function to get Apple Music status and track info
get_apple_music_info() {
    STATE=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)
    
    if [ "$STATE" = "playing" ]; then
        MEDIA=$(osascript -e 'tell application "Music" to get the name of the current track & " - " & the artist of the current track')
        echo "$MEDIA"
    else
        echo ""
    fi
}

# Fetch Spotify info
SPOTIFY_MEDIA=$(get_spotify_info)

if [ -n "$SPOTIFY_MEDIA" ]; then
    # If Spotify is playing, set the label to Spotify info
    echo "Spotify is playing: $SPOTIFY_MEDIA"
    sketchybar --set $NAME label="$SPOTIFY_MEDIA" drawing=on
else
    # If Spotify is not playing, check Apple Music
    APPLE_MEDIA=$(get_apple_music_info)
    
    if [ -n "$APPLE_MEDIA" ]; then
        # If Apple Music is playing, set the label to Apple Music info
        echo "Apple Music is playing: $APPLE_MEDIA"
        sketchybar --set $NAME label="$APPLE_MEDIA" drawing=on
    else
        # If neither Spotify nor Apple Music is playing, check the INFO var (e.g., YouTube)
        if [ -n "$INFO" ]; then
            STATE=$(echo "$INFO" | jq -r '.state')
            
            if [ "$STATE" = "playing" ]; then
                MEDIA=$(echo "$INFO" | jq -r '.title + " - " + .artist')
                echo "YouTube is playing: $MEDIA"
                sketchybar --set $NAME label="$MEDIA" drawing=on
            else
                # If no media is playing, turn off drawing
                sketchybar --set $NAME drawing=off
            fi
        else
            # If no INFO is provided, turn off drawing
            sketchybar --set $NAME drawing=off
        fi
    fi
fi