# mongodb-ami

MongoDB EC2 AMI created with packer.

## Steps for EC2 Instance Configuration

Once the AMI is created and an EC2 instance is launched from it, connect to the instance and modify the MongoDB configuration as follows:

### User Data Script

Add the following commands to the user script in the EC2 instance:

```bash
# Backup the original MongoDB configuration file
cp /etc/mongod.conf /etc/mongod.conf.backup

# Modify the bind IP to allow external connections
sed -i "s/^  bindIp:.*$/  bindIp: 0.0.0.0/" /etc/mongod.conf

# Restart the MongoDB service
sudo systemctl restart mongod
```

## Connect to MongoDB Instance

After the configuration, connect to the MongoDB instance either:

- **Locally** using [mongosh](https://www.mongodb.com/docs/mongodb-shell/).
- **Remotely** using [MongoDB Compass](https://www.mongodb.com/products/compass).

## Create an Admin User

Run the following MongoDB commands to create an admin user:

```bash
use admin
db.createUser({
  user: "username",
  pwd: "password",
  roles: [{ role: "userAdminAnyDatabase", db: "admin" }]
})
```

This will create a new admin user with the specified username and password.

# Enable MongoDB Authentication

To enable authentication, update the `/etc/mongod.conf` file with the following configuration:

```yaml
security:
  authorization: "enabled"
```

## Restart MongoDB

After enabling authentication, restart the MongoDB service by running the following command:

```bash
sudo systemctl restart mongod
```
