# README

## Setup:
### 1. Clone Repository
```
git clone git@github.com:arthurariza/teachable.git
cd teachable
```
### 2. Copy .env template
```
cp .env.template .env
cp .env.template .env.test
```
`Make sure to fill in the TEACHABLE_API_KEY`

### 3. Build docker images
```
docker compose build --no-cache
```
### 4. Start containers in background
```
docker compose up -d
```
### 5. Run database setup
```
docker compose exec app rails db:prepare
```
### 6. The server should be running on port 3000

## How To Run Specs
```
docker compose exec app rspec
```
## Stop Containers Running In Background
```
docker compose stop
```