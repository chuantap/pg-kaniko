package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

// IPResponse represents the JSON response from the IP API
type IPResponse struct {
	IP string `json:"ip"`
}

func getPublicIP() (string, error) {
	// Using ipify.org API - a simple, free service
	resp, err := http.Get("https://api.ipify.org?format=json")
	if err != nil {
		return "", fmt.Errorf("error fetching IP address: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("HTTP request failed with status: %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("error reading response body: %v", err)
	}

	var ipData IPResponse
	if err := json.Unmarshal(body, &ipData); err != nil {
		return "", fmt.Errorf("error parsing response: %v", err)
	}

	return ipData.IP, nil
}

func main() {
	fmt.Println("Fetching your public IP address...")

	publicIP, err := getPublicIP()
	if err != nil {
		fmt.Printf("Failed to retrieve public IP address: %v\n", err)
		return
	}

	fmt.Printf("Your public IP address is: %s\n", publicIP)
} 