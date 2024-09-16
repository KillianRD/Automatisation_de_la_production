install:
	bin/composer install

start:
	php -S localhost:8080

test:
	# cd tst && ../vendor/bin/phpunit
	XDEBUG_MODE=coverage ./vendor/bin/phpunit --coverage-text=log/coverage.txt --coverage-html=log/php-coverage-report tst
